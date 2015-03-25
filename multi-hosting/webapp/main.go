package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

func main() {
	type Data map[string]interface{}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()
		data := Data{
			"Hostname":    hostname,
			"Environment": os.Environ(),
		}
		b, err := json.MarshalIndent(data, "", " ")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(b)
	})

	log.Fatal(http.ListenAndServe(":3000", nil))
}
