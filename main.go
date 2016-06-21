package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"text/template"
)

var f1 = Field{
	FieldName: "id",
	FieldType: "bson.ObjectId",
	FieldAnn:  "",
}

//字段
type Field struct {
	FieldName string `json:"fName"`
	FieldType string `json:"fType"`
	FieldAnn  string `json:"anno,omitempty"`
	IsMust    bool   `json:"isMust"`
}

//方法
type Method struct {
	MethodName string  `json:"methodName"`
	Params     []Field `json:"params,omitempty"`
	ReturnType []Field `json:"returnType,omitempty"`
}

//模型
type Modle struct {
	Name       string   `json:"name"`
	PkgName    string   `json:"pkgName"`
	Fileds     []Field  `json:"fields"`
	Methods    []Method `json:"methods"`
	Annotation string   `json:"annotation,omitempty"`
}

// ToUpper 大写
func ToUpper(content string) string {
	return strings.ToTitle(content)
}

func main() {

	// apigenerate -n "mc" [dir]

	name := flag.String("n", "", "models名字")
	outPath := flag.String("d", ".", "输出路径")
	flag.Parse()
	modleName := *name
	if modleName == "" {
		fmt.Println("models not empty1")
		os.Exit(1)
	}
	out := *outPath
	if out == "" || out == "." {
		out, _ = os.Getwd()
	}

	fmt.Printf("name:%s\noutpath:%s\n", modleName, out)
	var model Modle
	model.Name = modleName
	model.PkgName = "models"
	model.Fileds = []Field{f1}

	currentPath := getCurrPath()
	currentPath = getParentDirectory(currentPath)
	tmplPath := filepath.Join(currentPath, "src", "apigenerate", "model.tpl")

	funcMap := template.FuncMap{
		"toLower": func(content string) string {
			return strings.ToLower(content)
		},
		"toTitle": func(content string) string {
			return strings.Title(content)
		},
	}

	tmpl := template.New("model.tpl")
	tmpl.Funcs(funcMap)
	tmpl = template.Must(tmpl.ParseFiles(tmplPath))
	// tmpl = tmpl.Funcs(funcMap)
	//
	fileNname := strings.ToLower(model.Name)
	// tmplOut := filepath.Join(currentPath, "models", fileNname+".go")
	tmplOut := filepath.Join(out, fileNname+".go")
	outFile, _ := os.OpenFile(tmplOut, os.O_RDWR|os.O_CREATE, os.ModePerm)
	defer outFile.Close()
	tmpl.Execute(outFile, model)
}

func getCurrPath() string {
	file, _ := exec.LookPath(os.Args[0])
	path, _ := filepath.Abs(file)
	index := strings.LastIndex(path, string(os.PathSeparator))
	ret := path[:index]
	return ret
}

func subStr(s string, pos, length int) string {
	runes := []rune(s)
	l := pos + length
	if l > len(runes) {
		l = len(runes)
	}
	return string(runes[pos:l])
}

func getParentDirectory(dirctory string) string {
	return subStr(dirctory, 0, strings.LastIndex(dirctory, "/"))
}
