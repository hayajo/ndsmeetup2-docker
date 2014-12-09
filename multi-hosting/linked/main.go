package main

import (
	"fmt"
	"net/url"
	"os"
	"strings"
	"time"

	"github.com/fsouza/go-dockerclient"
	"github.com/garyburd/redigo/redis"
)

const (
	REDIS_PORT = 6379
)

func httpPort(port int64) bool {
	switch port {
	case 80, 3000, 5000, 5004, 8000, 8080:
		return true
	}
	return false
}

func redisAddress(redisUrl string) (string, error) {
	var address string

	u, err := url.Parse(redisUrl)
	if err != nil {
		return address, err
	}

	if u.Scheme != "redis" && u.Scheme != "tcp" {
		return address, fmt.Errorf("Support only redis or tcp scheme: %s", redisUrl)
	}

	host := u.Host
	if strings.Contains(host, ":") {
		return host, nil
	}

	return fmt.Sprintf("%s:%d", host, REDIS_PORT), nil
}

func setToRedis(redisUrl string, dests map[string]string) {
	address, err := redisAddress(redisUrl)
	if err != nil {
		fmt.Fprint(os.Stderr, err)
		return
	}

	r, err := redis.Dial("tcp", address)
	if err != nil {
		fmt.Fprint(os.Stderr, "Failed to connect redis server:", err)
		return
	}

	defer r.Close()

	for name, dest := range dests {
		r.Do("SET", name, dest)
	}
}

func getDests(dockerUrl string) map[string]string {
	dests := make(map[string]string)

	d, err := docker.NewClient(dockerUrl)
	if err != nil {
		fmt.Fprint(os.Stderr, err)
		return dests
	}

	opts := docker.ListContainersOptions{}
	containers, err := d.ListContainers(opts)
	if err != nil {
		fmt.Fprint(os.Stderr, err)
		return dests
	}

	for _, c := range containers {
		for _, p := range c.Ports {
			if p.IP == "0.0.0.0" && p.Type == "tcp" && httpPort(p.PrivatePort) {
				i, _ := d.InspectContainer(c.ID)
				name := strings.TrimLeft(i.Name, "/")
				dest := fmt.Sprintf("%s:%d", i.NetworkSettings.IPAddress, p.PrivatePort)
				dests[name] = dest
			}
		}
	}

	return dests
}

func main() {
	var dockerUrl = "unix:///var/run/docker.sock"
	var redisUrl = fmt.Sprintf("redis://%s:%d", "127.0.0.1", REDIS_PORT)

	if u := os.Getenv("DOCKER_URL"); u != "" {
		dockerUrl = u
	}

	if u := os.Getenv("REDIS_URL"); u != "" {
		redisUrl = u
	} else if u := os.Getenv("REDIS_PORT_6379_TCP"); u != "" {
		redisUrl = u
	}

	fmt.Println("docker url:", dockerUrl)
	fmt.Println(" redis url:", redisUrl)

	for {
		dests := getDests(dockerUrl)
		setToRedis(redisUrl, dests)
		time.Sleep(10 * time.Second)
	}
}
