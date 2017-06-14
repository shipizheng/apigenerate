package tpl

import (
	"html/template"
	"os"
	"path/filepath"
	"strings"
)

type Service struct {
	Name string
	Conf Conf
}

func NewService(name string) Service {
	var service Service
	service.Name = name
	return service
}
func (s *Service) Delete() {
	currentPath := GetCurrPath(s.Conf.Dev)
	// fmt.Println("1:" + currentPath)
	currentPath = GetParentDirectory(currentPath)
	// fmt.Println("2:" + currentPath)
	tmplPath := filepath.Join(currentPath, "src", "github.com/shipizheng/apigenerate/tpl", "service.tpl")
	os.Remove(tmplPath)
}

func (s *Service) CodeGenerate() (bool, error) {
	currentPath := GetCurrPath(s.Conf.Dev)
	// fmt.Println("1:" + currentPath)
	currentPath = GetParentDirectory(currentPath)
	// fmt.Println("2:" + currentPath)
	tmplPath := filepath.Join(currentPath, "src", "github.com/shipizheng/apigenerate/tpl", "service.tpl")

	funcMap := template.FuncMap{
		"toLower": func(content string) string {
			return strings.ToLower(content)
		},
		"toTitle": func(content string) string {
			return strings.Title(content)
		},
	}

	tmpl := template.New("service.tpl")
	tmpl.Funcs(funcMap)
	tmpl = template.Must(tmpl.ParseFiles(tmplPath))

	fileNname := strings.ToLower(s.Name)
	// tmplOut := filepath.Join(currentPath, "models", fileNname+".go")
	if s.Conf.Out == "" || s.Conf.Out == "." {
		s.Conf.Out, _ = os.Getwd()
	}
	tmplOut := filepath.Join(s.Conf.Out, fileNname+"Service.go")
	outFile, errFile := os.OpenFile(tmplOut, os.O_RDWR|os.O_CREATE, os.ModePerm)
	defer outFile.Close()
	if errFile != nil {
		return false, errFile
	}
	errTpl := tmpl.Execute(outFile, s)
	if errTpl != nil {
		return false, errTpl
	}
	return true, nil
}
