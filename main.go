package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/shipizheng/apigenerate/tpl"
)

var help = `1.  service -n -d 
2.  dao -n -d  `

const (
	ServiceCmd = "service"
	DaoCmd     = "dao"
)

func main() {

	if len(os.Args) < 2 {
		fmt.Println("list or count subcommand is required")
		os.Exit(1)
	}
	cmdName := os.Args[1]
	switch cmdName {
	case ServiceCmd:
		serviceCmd := flag.NewFlagSet("service", flag.ExitOnError)
		name := serviceCmd.String("n", "", "名字")
		outPath := serviceCmd.String("d", ".", "输出路径")
		serviceCmd.Parse(os.Args[2:])
		if name == nil || *name == "" {
			fmt.Printf("请输入 <%s> 命令 生成的文件名 \n", cmdName)
			return
		}
		fmt.Printf("%s starting generate %s...\n", cmdName, *name)
		service := tpl.NewService(*name)
		service.Conf = tpl.Conf{
			Dev: true,
			Out: *outPath,
		}
		b, err := service.CodeGenerate()
		if err != nil {
			// panic(err)
			fmt.Errorf("%s", err)
			return
		}
		if b {
			fmt.Printf("生成%v成功\n", *name)
		}
	case DaoCmd:
		daoCmd := flag.NewFlagSet("dao", flag.ExitOnError)
		name := daoCmd.String("n", "", "名字")
		outPath := daoCmd.String("d", ".", "输出路径")
		daoCmd.Parse(os.Args[2:])
		if name == nil || *name == "" {
			fmt.Printf("请输入 <%s> 命令 生成的文件名 \n", cmdName)
			return
		}
		fmt.Printf("%s starting generate %s...\n", cmdName, *name)
		dao := tpl.NewDao(*name)
		dao.Conf = tpl.Conf{
			Dev: true,
			Out: *outPath,
		}
		b, err := dao.CodeGenerate()
		if err != nil {
			// panic(err)
			fmt.Errorf("%s", err)
			return
		}
		if b {
			fmt.Printf("生成%v成功\n", *name)
		}
	default:
		// serviceCmd.PrintDefaults()
	}

}
