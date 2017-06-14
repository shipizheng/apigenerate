package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/shipizheng/apigenerate/tpl"
)

var help = `apigenerate service -n ""`

const (
	ServiceCmd = "service"
)

func main() {
	serviceCmd := flag.NewFlagSet("service", flag.ExitOnError)
	name := serviceCmd.String("n", "", "名字")
	outPath := serviceCmd.String("d", ".", "输出路径")
	if len(os.Args) < 2 {
		fmt.Println("list or count subcommand is required")
		os.Exit(1)
	}
	// if !flag.Parsed() {
	serviceCmd.Parse(os.Args[2:])
	// }
	fmt.Println(*name)
	cmdName := os.Args[1]
	if name == nil || *name == "" {
		fmt.Printf("请输入 <%s> 命令 生成的文件名 \n", cmdName)
		return
	}
	fmt.Printf("%s starting generate %s...\n", cmdName, *name)
	switch cmdName {
	case ServiceCmd:
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
	default:
		serviceCmd.PrintDefaults()
	}

}
