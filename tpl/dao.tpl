package dao
{{$name:= .Name | toLower }}
const (
	{{$name}}ColletinName string = "{{$name -}}"
)

type {{.Name}}Dao struct {
	*Dao
}

func (d *{{.Name}}Dao) Add(object models.{{.Name}}) (*models.{{.Name}}, error) {
	currentTime := time.Now()
	object.Created = &currentTime
	result, err := govalidator.ValidateStruct(&object)
	if !result {
		if err != nil {
			return nil, err
		}
	}
	dbOpt := func(col *mgo.Collection) error {
		return col.Insert(&object)
	}
	err = d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, err
	}
	return &object, nil
}

func (d *{{.Name}}Dao) BulkAdd(objects []interface{}) (interface{}, error) {
	dbOpt := func(col *mgo.Collection) error {
		return col.Insert(objects...)
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, err
	}
	return objects, nil
}

func (d *{{.Name}}Dao) Update(findOpt, updateOpt bson.M) error {
	v, ok := updateOpt["$set"]
	if !ok {
		return  errors.New("update must have $set")
	}
	nowTime := time.Now().Local()
	if v1, ok1 := v.(bson.M); ok1 {
		v1["updated"] = &nowTime
	}
	dbOpt := func(col *mgo.Collection) error {
		return col.Update(findOpt, updateOpt)
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return err
	}
	return nil
}

func (d *{{.Name}}Dao) ApplayUpdate(findOpt, updateOpt bson.M,upsert bool, isReturn bool) (*models.{{.Name}},*mgo.ChangeInfo, error) {
	var newResult models.{{.Name}}
	var changeInfo *mgo.ChangeInfo
	v, ok := updateOpt["$set"]
	if !ok {
		return nil, nil, errors.New("update must have $set")
	}
	nowTime := time.Now().Local()
	if v1, ok1 := v.(bson.M); ok1 {
		v1["updated"] = &nowTime
	}
	dbOpt := func(col *mgo.Collection) error {
		change := mgo.Change{
			Update:    updateOpt,
			Upsert:    upsert,
			ReturnNew: isReturn,
		}
		i, err := col.Find(findOpt).Apply(change, &newResult)
		changeInfo = i
		return err
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, changeInfo,err
	}
	return &newResult, changeInfo,nil
}

func (d *{{.Name}}Dao) Finds(findOpt bson.M, selectOpt bson.M, ss ...string) ([]models.{{.Name}}, error) {
	var objects []models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		if len(ss) > 0 {
			return col.Find(findOpt).Select(selectOpt).Sort(strings.Join(ss, ",")).All(&objects)
		}
		return col.Find(findOpt).Select(selectOpt).All(&objects)
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, err
	}
	return objects, nil
}

func (d *{{.Name}}Dao) Count(findOpt bson.M) (int, error) {
	var count int
	dbOpt := func(col *mgo.Collection) error {
		c, err := col.Find(findOpt).Count()
		count = c
		return err
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return count, err
	}
	return count, nil
}

func (d *{{.Name}}Dao) FindLimit(findOpt bson.M, selectOpt bson.M, start, count int, ss ...string) (*models.List{{.Name}}, error) {
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
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, err
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

func (d *{{.Name}}Dao) Delete(objectId string) (*models.{{.Name}}, error) {
	var object models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		return col.RemoveId(bson.ObjectIdHex(objectId))
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return nil, err
	}
	return &object, nil
}



func (d *{{.Name}}Dao) IsExist(findOpt bson.M) (bool, error) {
	var num int
	dbOpt := func(col *mgo.Collection) error {
		count, err := col.Find(findOpt).Count()
		num = count
		return err
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)
	if err != nil {
		return false, err
	}
	return num > 0, nil
}

func (d *{{.Name}}Dao) Get(findOpt, selectOpt bson.M) (*models.{{.Name}}, error) {

	var result models.{{.Name}}
	dbOpt := func(col *mgo.Collection) error {
		return col.Find(findOpt).Select(selectOpt).One(&result)
	}
	err := d.Dao.DBAction(DBName, {{$name}}ColletinName, dbOpt)

	if err != nil {
		return nil, err
	}
	return &result, nil
}
