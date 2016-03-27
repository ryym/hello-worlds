package main

import (
    "golang.org/x/tour/tree"
    "fmt"
)

func _Walk(t *tree.Tree, ch chan int) {
    if t.Left != nil {
        _Walk(t.Left, ch)
    }

    ch <- t.Value

    if t.Right != nil {
        _Walk(t.Right, ch)
    }
}

func Walk(t *tree.Tree, ch chan int) {
    _Walk(t, ch)
    close(ch)
}

func WalkTest() {
    aTree := tree.New(1)
    fmt.Println(aTree)

    ch := make(chan int)
    go Walk(aTree, ch)

    for v := range ch {
        fmt.Println(v)
    }
}

func Same(t1 *tree.Tree, t2 *tree.Tree) bool {
    ch1 := make(chan int)
    ch2 := make(chan int)

    go Walk(t1, ch1)
    go Walk(t2, ch2)

    for v1 := range ch1 {
        v2 := <-ch2
        if v1 != v2 {
            return false
        }
    }
    return true
}

func SameTest() {
    fmt.Println("Should be true:" + fmt.Sprint(Same(tree.New(1), tree.New(1))))
    fmt.Println("Should be false:" + fmt.Sprint(Same(tree.New(1), tree.New(2))))
}

func main() {
    WalkTest()
    SameTest()
}
