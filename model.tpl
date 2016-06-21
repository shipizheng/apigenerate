package {{.PkgName}}
{{$name:= .Name | toLower }}

import (
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"{{.ProjectName}}/services"
)

type {{ .Name }} struct {
	{{range .Fileds}} {{.FieldName | toTitle}} {{.FieldType}} {{if .IsMust}}`json:"{{.FieldName | toLower}}"` {{else}} `bson:"{{.FieldName | toLower}},omitempty" json:"{{.FieldName | toLower}},omitempty"` {{end}} //{{.FieldAnn}}
	{{end}}
}

func Add{{.Name}}(service *services.Service, {{$name}} *{{.Name}}) error {
	insertdbcal := func(col *mgo.Collection) error {
		return col.Insert({{$name}}) 
	}
	err := service.Action("{{$name}}", insertdbcal)
	return err
}

func Find{{.Name}}s(service *services.Service) ([]{{.Name}}, error) {
	var {{$name}} []{{.Name}}
	dbcal := func(col *mgo.Collection) error {
		return col.Find(nil).All(&{{$name}})
	}
	err := service.Action("{{$name}}", dbcal)
	return {{$name}}, err
}

func FilterSingle{{.Name}}(service *services.Service, docs []bson.M) ({{.Name}}, error) {
	var {{$name}} {{.Name}}
	dbcal := func(col *mgo.Collection) error {
		return col.Find(docs[0]).Select(docs[1]).One(&{{$name}})
	}
	err := service.Action("{{$name}}", dbcal)
	return {{$name}}, err
}

func Filter{{.Name}}(service *services.Service, limit, offset int,docs ...bson.M) ([]{{.Name}}, error) {
	var {{$name}}s []{{.Name}}
	dbcal := func(col *mgo.Collection) error {
		if len(docs) > 1 {
			if limit == 0 {
				return col.Find(docs[0]).Select(docs[1]).All(&{{$name}}s)
			}
			return col.Find(docs[0]).Skip(offset).Limit(limit).Select(docs[1]).All(&{{$name}}s)

		}
		if limit == 0 {
			return col.Find(docs[0]).All(&{{$name}}s)
		}
		return col.Find(docs[0]).Skip(offset).Limit(limit).All(&{{$name}}s)

	}
	err := service.Action("{{$name}}", dbcal)
	return {{$name}}s, err
}

func Get{{.Name}}ByDoc(service *services.Service, doc bson.M) ({{.Name}}, error) {
	var {{$name}} {{.Name}}
	dbcal := func(col *mgo.Collection) error {
		return col.Find(doc).One(&{{$name}})
	}
	err := service.Action("{{$name}}", dbcal)
	return {{$name}} , err
}

func Update{{.Name}}ByDoc(service *services.Service, doc ...interface{}) error {
	dbcal := func(col *mgo.Collection) error {

		return col.Update(doc[0], doc[1])
	}
	err := service.Action("{{$name}}", dbcal)
	return err
}

func Remove{{.Name}}(service *services.Service, gid string) error {
	opt := bson.M{"_id": bson.ObjectIdHex(gid)}
	removedbcal := func(col *mgo.Collection) error {
		return col.Remove(opt)
	}
	err := service.Action("{{$name}}", removedbcal)
	return err
}

func Remove{{.Name}}ByDoc(service *services.Service, doc bson.M) error {
	removedbcal := func(col *mgo.Collection) error {
		return col.Remove(doc)
	}
	err := service.Action("{{$name}}", removedbcal)
	return err
}
//findAndModify,找到并修改。
func AtomOp{{.Name}}(service *services.Service, doc ...bson.M) ({{.Name}}, error) {
	var {{$name}} {{.Name}}
	dbcal := func(col *mgo.Collection) error {
		change := mgo.Change{
			Update:    doc[1],
			ReturnNew: true,
		}
		_, err := col.Find(doc[0]).Apply(change, &{{$name}})
		return err
	}
	err := service.Action("{{$name}}", dbcal)
	return {{$name}}, err
}


