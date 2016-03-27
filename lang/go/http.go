package main

import (
	"fmt"
	"log"
	"net/http"
)

type Hello struct {}

func (h Hello) ServeHTTP (
	w http.ResponseWriter,
	r *http.Request) {
	fmt.Fprint(w, "Hello!")
}

func sayHello() {
	var h Hello
	fmt.Println("Start listening.")
	err := http.ListenAndServe("localhost:4000", h)
	if err != nil {
		log.Fatal(err)
	}
}

type String string

type Struct struct {
	Greeting string
	Punct    string
	Who      string
}

func (s String) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, s)
}
func (s Struct) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, s)
}

func main() {
	http.Handle("/string", String("I'm a frayed knot."))
	http.Handle("/struct", Struct {"Hello", ":", "Gopher!"})

	fmt.Println("start listening.")
	log.Fatal( http.ListenAndServe("localhost:4000", nil) )
}
