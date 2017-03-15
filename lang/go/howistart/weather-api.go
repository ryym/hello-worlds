// To run: `go run weather-providers.go weather-api.go`

package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

func main() {
	apiKey := os.Getenv("WEATHER_API_KEY")
	if apiKey == "" {
		log.Fatal("Spefify WEATHER_API_KEY environment variable")
		return
	}

	mw := multiWeatherProvider{
		timeoutSec: 10,
		providers: []weatherProvider{
			openWeatherMap{apiKey: apiKey},
			bullshitWeatherProvider{},
		},
	}

	http.HandleFunc("/weather/", func(w http.ResponseWriter, r *http.Request) {
		begin := time.Now()
		city := strings.SplitN(r.URL.Path, "/", 3)[2]

		temp, err := mw.temperature(city)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "appication/json; charset=utf-8")

		json.NewEncoder(w).Encode(map[string]interface{}{
			"city": city,
			"temp": temp,
			"took": time.Since(begin).String(),
		})
	})

	log.Println("Server started (8080)")
	http.ListenAndServe(":8080", nil)
}
