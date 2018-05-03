package tpl

import "testing"
import "github.com/smartystreets/goconvey/convey"

func TestGenerateService(t *testing.T) {
	service := NewService("Order")
	service.Conf = Conf{
		Dev: true,
	}
	// service.Delete()
	b, err := service.CodeGenerate()
	convey.Convey("是否生成成功", t, func() {
		convey.ShouldBeNil(err, nil)
		convey.ShouldBeTrue(b, true)
	})
}
