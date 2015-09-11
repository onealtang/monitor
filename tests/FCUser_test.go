package test

import (
	"crypto/md5"
	"encoding/hex"
	"testing"
	"fmt"
)

func Pwdhash(str string) string {
	md5bytes := md5.Sum([]byte(str))
	return hex.EncodeToString(md5bytes[:])
}

func TestPwdhash(*testing.T) {
	pwd := "m@d2015"
	encodedPwd := Pwdhash(pwd);

	fmt.Println()
	fmt.Println(encodedPwd)
	fmt.Println()
}
