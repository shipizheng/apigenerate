package tpl

import (
	"html/template"
	"os"
	"path/filepath"
	"strings"
)

type Dao struct {
	Name string
	Conf Conf
}

func NewDao(name string) Dao {
	var dao Dao
	dao.Name = name
	return dao
}
func (s *Dao) Delete() {
	currentPath := GetCurrPath(s.Conf.Dev)
	// fmt.Println("1:" + currentPath)
	currentPath = GetParentDirectory(currentPath)
	// fmt.Println("2:" + currentPath)
	tmplPath := filepath.Join(currentPath, "src", "github.com/shipizheng/apigenerate/tpl", "dao.tpl")
	os.Remove(tmplPath)
}

func (s *Dao) CodeGenerate() (bool, error) {
	currentPath := GetCurrPath(s.Conf.Dev)
	// fmt.Println("1:" + currentPath)
	currentPath = GetParentDirectory(currentPath)
	// fmt.Println("2:" + currentPath)
	tmplPath := filepath.Join(currentPath, "src", "github.com/shipizheng/apigenerate/tpl", "dao.tpl")

	funcMap := template.FuncMap{
		"toLower": func(content string) string {
			return strings.ToLower(content)
		},
		"toTitle": func(content string) string {
			return strings.Title(content)
		},
	}

	tmpl := template.New("dao.tpl")
	tmpl.Funcs(funcMap)
	tmpl = template.Must(tmpl.ParseFiles(tmplPath))

	fileNname := strings.ToLower(s.Name)
	// tmplOut := filepath.Join(currentPath, "models", fileNname+".go")
	if s.Conf.Out == "" || s.Conf.Out == "." {
		s.Conf.Out, _ = os.Getwd()
	}
	tmplOut := filepath.Join(s.Conf.Out, fileNname+"Dao.go")
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
