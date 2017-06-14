package tpl

import (
	"testing"
)

func TestToLower(t *testing.T) {
	type args struct {
		content string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
	// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ToLower(tt.args.content); got != tt.want {
				t.Errorf("ToLower() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestGetCurrPath(t *testing.T) {
	type args struct {
		dev bool
	}
	tests := []struct {
		name string
		args args
		want string
	}{
	// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := GetCurrPath(tt.args.dev); got != tt.want {
				t.Errorf("GetCurrPath() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestSubStr(t *testing.T) {
	type args struct {
		s      string
		pos    int
		length int
	}
	tests := []struct {
		name string
		args args
		want string
	}{
	// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := SubStr(tt.args.s, tt.args.pos, tt.args.length); got != tt.want {
				t.Errorf("SubStr() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestGetParentDirectory(t *testing.T) {
	type args struct {
		dirctory string
	}
	tests := []struct {
		name string
		args args
		want string
	}{
	// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := GetParentDirectory(tt.args.dirctory); got != tt.want {
				t.Errorf("GetParentDirectory() = %v, want %v", got, tt.want)
			}
		})
	}
}
