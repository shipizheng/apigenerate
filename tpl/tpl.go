package tpl

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

type Tpl interface {
	CodeGenerate() (bool, error)
	Import() (bool,error)
}


func ToLower(content string) string {
	return strings.ToLower(content)
}

func Totitle(content string) string {
	return strings.Title(content)
}

func GetCurrPath(dev bool) string {
	if dev {
		return "/Users/shiyuan/doucment/golang/project/"
	}
	file, _ := exec.LookPath(os.Args[0])
	path, _ := filepath.Abs(file)
	index := strings.LastIndex(path, string(os.PathSeparator))
	ret := path[:index]
	return ret
}

func SubStr(s string, pos, length int) string {
	runes := []rune(s)
	l := pos + length
	if l > len(runes) {
		l = len(runes)
	}
	return string(runes[pos:l])
}

func GetParentDirectory(dirctory string) string {
	return SubStr(dirctory, 0, strings.LastIndex(dirctory, string(os.PathSeparator)))
}
