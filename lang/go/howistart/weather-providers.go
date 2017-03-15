package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

type weatherProvider interface {
	temperature(city string) (float64, error)
}

type openWeatherMap struct {
	apiKey string
}

const WEATHER_API_URL = "http://api.openweathermap.org/data/2.5/weather"

func (w openWeatherMap) temperature(city string) (float64, error) {
	url := fmt.Sprintf("%s?APPID=%s&q=%s", WEATHER_API_URL, w.apiKey, city)
	resp, err := http.Get(url)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	var d struct {
		Main struct {
			Kelvin float64 `json:"temp"`
		} `json:"main"`
	}

	if err := json.NewDecoder(resp.Body).Decode(&d); err != nil {
		return 0, err
	}

	return d.Main.Kelvin, nil
}

type bullshitWeatherProvider struct{}

func (w bullshitWeatherProvider) temperature(city string) (float64, error) {
	time.Sleep(500 * time.Millisecond)
	return rand.Float64() * float64(len(city)), nil
}

type multiWeatherProvider []weatherProvider

func (w multiWeatherProvider) temperature(city string) (float64, error) {
	sum := 0.0

	for _, provider := range w {
		k, err := provider.temperature(city)
		if err != nil {
			return 0, err
		}
		sum += k
	}

	return sum / float64(len(w)), nil
}
