package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("Hello World !")
	time.Sleep(60*60*24 * time.Second)
	fmt.Println("Hello World !")
}