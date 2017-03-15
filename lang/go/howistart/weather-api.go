package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
)

type weatherData struct {
	Name string `json:"name"`
	Main struct {
		Kelvin float64 `json:"temp"`
	} `json:"main"`
}

const WEATHER_API_URL = "http://api.openweathermap.org/data/2.5/weather"

func main() {
	apiKey := os.Getenv("WEATHER_API_KEY")
	if apiKey == "" {
		fmt.Println("API KEY is required.")
		return
	}

	http.HandleFunc("/weather/", func(w http.ResponseWriter, r *http.Request) {
		city := strings.SplitN(r.URL.Path, "/", 3)[2]

		data, err := query(apiKey, city)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		json.NewEncoder(w).Encode(data)
	})

	fmt.Println("Server started")
	http.ListenAndServe(":8080", nil)
}

func query(apiKey, city string) (weatherData, error) {
	url := fmt.Sprintf("%s?APPID=%s&q=%s", WEATHER_API_URL, apiKey, city)
	resp, err := http.Get(url)
	if err != nil {
		return weatherData{}, err
	}
	defer resp.Body.Close()

	var d weatherData

	if err := json.NewDecoder(resp.Body).Decode(&d); err != nil {
		return weatherData{}, err
	}

	return d, nil
}
