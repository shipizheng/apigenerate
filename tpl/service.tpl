package services
{{$name:= .Name | toLower }}
const (
	{{$name}}ColletinName string = "{{$name -}}"
)

type {{.Name}}Service struct {
	*Service
}

func (svc *{{.Name}}Service) Add(object models.{{.Name}}) (*models.{{.Name}}, *errs.Error) {
	currentTime := time.Now()
	object.Created = &currentTime
	result, err := govalidator.ValidateStruct(&object)
	fmt.Println(result)
	if !result {
		if err != nil {
			return nil, errs.NewError(400, err.Error())
		}
	}
	dbOpt := func(col *mgo.Collection) error {
		return col.Insert(&object)
	}
	err = svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return &object, nil
}

func (svc *{{.Name}}Service) BulkAdd(objects []interface{}) (interface{}, *errs.Error) {
	dbOpt := func(col *mgo.Collection) error {
		return col.Insert(objects...)
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return objects, nil
}

func (svc *{{.Name}}Service) Update(objectId string, updateOpt bson.M) *errs.Error {
	if objectId == "" {
		return errs.NewError(400, "pid not empty")
	}

	dbOpt := func(col *mgo.Collection) error {
		return col.UpdateId(bson.ObjectIdHex(objectId), updateOpt)
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return errs.NewError(500, err.Error())
	}
	return nil
}

func (svc *{{.Name}}Service) ApplayUpdate(findOpt, updateOpt bson.M) (*models.{{.Name}}, *errs.Error) {
	var newResult models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		change := mgo.Change{
			Update:    updateOpt,
			ReturnNew: true,
		}
		_, err := col.Find(findOpt).Apply(change, &newResult)
		return err
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return &newResult, nil
}

func (svc *{{.Name}}Service) Finds(findOpt bson.M, selectOpt bson.M, ss ...string) ([]models.{{.Name}}, *errs.Error) {
	var objects []models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		if len(ss) > 0 {
			return col.Find(findOpt).Select(selectOpt).Sort(strings.Join(ss, ",")).All(&objects)
		}
		return col.Find(findOpt).Select(selectOpt).All(&objects)
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return objects, nil
}

func (svc *{{.Name}}Service) Count(findOpt bson.M) (int, error) {
	var count int
	dbOpt := func(col *mgo.Collection) error {
		c, err := col.Find(findOpt).Count()
		count = c
		return err
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return count, nil
}

func (svc *{{.Name}}Service) FindLimit(findOpt bson.M, selectOpt bson.M, start, count int, ss ...string) (*models.List{{.Name}}, *errs.Error) {
	var objects []models.{{.Name}}
	var totalCount int
	dbOpt := func(col *mgo.Collection) error {
		q := col.Find(findOpt)
		totalCount, _ = q.Count()
		if len(ss) > 0 {
			return q.Select(selectOpt).Sort(strings.Join(ss, ",")).Skip(start).Limit(count).All(&objects)
		}
		return col.Find(findOpt).Select(selectOpt).Skip(start).Limit(count).All(&objects)
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	if objects == nil {
		objects = make([]models.{{.Name}}, 0)
	}
	var result models.List{{.Name}}
	result.Start = start
	result.Count = count
	result.Total = totalCount
	result.Targets = objects
	return &result, nil
}

func (svc *{{.Name}}Service) Delete(objectId string) (*models.{{.Name}}, *errs.Error) {
	var object models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		return col.RemoveId(bson.ObjectIdHex(objectId))
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return &object, nil
}



func (svc *{{.Name}}Service) IsExist(findOpt bson.M) (bool, error) {
	var num int
	dbOpt := func(col *mgo.Collection) error {
		count, err := col.Find(findOpt).Count()
		num = count
		return err
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return false, err
	}
	return num > 0, nil
}

func (svc *{{.Name}}Service) Get(findOpt, selectOpt bson.M) (*models.{{.Name}}, error) {

	var result models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		return col.Find(findOpt).Select(selectOpt).One(&result)
	}
	err := svc.Service.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, errs.NewError(500, err.Error())
	}
	return &result, nil
}
