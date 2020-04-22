//
//  TestConstants.swift
//  swaapTests
//
//  Created by Michael Redig on 12/18/19.
//  Copyright © 2019 swaap. All rights reserved.
//
//swiftlint:disable line_length

import Foundation

let neAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlEwSkRRVVEyTjBORU5USkJNVVF5TWtKRlJqYzFSVFV5UWtFMlJVUkNSRVU1UVRVMFJFSkNRZyJ9.eyJpc3MiOiJodHRwczovL2Rldi0xbGV6NWdhaC5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NWRlYzYyNjgxNWUyMmYwZTc1M2RiMTA4IiwiYXVkIjpbImh0dHBzOi8vYXBpLnN3YWFwLmNvLyIsImh0dHBzOi8vZGV2LTFsZXo1Z2FoLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE1NzY4MjkwNTYsImV4cCI6MTU3NjkxNTQ1NiwiYXpwIjoiNGZkU3BZQ2I4c1l5N2RpTU8wZm5zcjVqRXQ1MDFPWmciLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIn0.0YbpI_V7NjVz_4jymNyghjyh3krtDDIRJtIf25-4OXQj0y1DfHetY2dtCzPoR4h2glVLqSlq71D57POSBGjfQs45cuPWSdVq6qGtuDKO_2LSIAEqXn02npmJfCOGYbGrwNh-qI1BtWbVSciDjxhXddeUOPFyIDxAQo3nkGsfEFCY4E1CZb2qHZFw96873pZYffZ9F3Z_Bi4xdzIGQel-2ntlQHndP6mH0hDsZIl6YrCVJ07Ct1XbOU_sOeP3zH3fC1l4zQ3ao62oqezJLuygZiBlo6q6y3RThdf4TbFZutCJZiYK45rzelFsviC2UYYPQ25YFRiAP5TnVsUdKkflSg"

let neIDToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlEwSkRRVVEyTjBORU5USkJNVVF5TWtKRlJqYzFSVFV5UWtFMlJVUkNSRVU1UVRVMFJFSkNRZyJ9.eyJuaWNrbmFtZSI6Im5lIiwibmFtZSI6Im5lQG5vLm51bSIsInBpY3R1cmUiOiJodHRwczovL3MuZ3JhdmF0YXIuY29tL2F2YXRhci82ODU3YzhmMmMwNmZkM2I4YmNhZWMyMjMyOGEwZWQ5Nj9zPTQ4MCZyPXBnJmQ9aHR0cHMlM0ElMkYlMkZjZG4uYXV0aDAuY29tJTJGYXZhdGFycyUyRm5lLnBuZyIsInVwZGF0ZWRfYXQiOiIyMDE5LTEyLTIwVDA4OjA0OjE2LjQ2MVoiLCJlbWFpbCI6Im5lQG5vLm51bSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiaXNzIjoiaHR0cHM6Ly9kZXYtMWxlejVnYWguYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZWM2MjY4MTVlMjJmMGU3NTNkYjEwOCIsImF1ZCI6IjRmZFNwWUNiOHNZeTdkaU1PMGZuc3I1akV0NTAxT1pnIiwiaWF0IjoxNTc2ODI5MDU2LCJleHAiOjE1NzY5MTU0NTZ9.IQ9no4UMXjFgFcGpANmH7UGfekAPv98X5pvXPvzUmCS1I63dUea4S6cvDwr8duslVeh9hg94NIWyXdS2IBp2Evg9FBOzWqeLytaaMqAm1qqo02f2B2vk_EJkNGFDoa4IYopyVTFRpTBZLgre1VSzyMB5yLFaVmvA_vJbb9llv5G_1Vn5bZ_9Zfl2efove4FnXsap4krfHag5ZBfFQCo5j3WCEbEo69JQzlr7agY4lHC4QsFVdpi2gEWMIQeTyGDc5D9eSzxVl3QxWoIC1w5imnFt-DrPK8yPg-nIjWDkwCW2IfU5iTSj4BgckgXhXwpTL24BE6JPAW7AfyMTh_L7Rw"

let testTokenType = "Bearer"

// MARK: - create connection
let createConnectionResponse = ##"{"data":{"createConnection":{"success":true,"code":201,"message":"Connection created successfully!"}}}"##.data(using: .utf8)!

let qrCodeQueryResponse = ##"{"data":{"qrcode":{"id":"ck4el1osu00cj0786xjugz4ig","label":"Default","scans":0,"user":{"id":"ck4eik11p00550786r8wxoxcw","authId":"5dd621e3dca5dc0f1d7240d3","name":"He Humasdf","picture":"https://placekitten.com/1000/1000","birthdate":"5/6/1445","location":"Round Table","industry":"Chivalry","jobtitle":"Paladin","tagline":"Not a knight of ni","bio":"I think Arthur’s got the right idea.","profile":[{"id":"ck4f9biir000y07973paxd9a6","value":"asdffdsa","type":"INSTAGRAM","privacy":"PUBLIC","preferredContact":true}]}}}}"##.data(using: .utf8)!

let arbitraryUserQueryResponse = ##"{"data":{"user":{"id":"ck4f11dt200080774s2l6yrva","authId":"5deca3a3ff9c9c0cc1ef7677","name":"ge@go.gum","tagline":null,"picture":"https://s.gravatar.com/avatar/85af7052866fde94b3a9bc90701b7f46?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fge.png","location":null,"birthdate":null,"industry":null,"jobtitle":null,"bio":null,"profile":[{"id":"ck4f11dwl000e07741ur39wn3","value":"gegogum","type":"TWITTER","privacy":"PUBLIC","preferredContact":true}]}}}"##.data(using: .utf8)!

let currentUserQueryResponse = ##"{"data":{"user":{"id":"ck4et6eyv00390746s87sniwq","authId":"5dec626815e22f0e753db108","name":"Ne Num","picture":"https://s.gravatar.com/avatar/6857c8f2c06fd3b8bcaec22328a0ed96?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fne.png","birthdate":"5/6/1445","location":"Round Table","industry":"Chivalry","jobtitle":"Paladin","tagline":"Not a knight of ni","bio":"I think Arthur’s got the right idea.","profile":[{"id":"ck4et6f11003f07464wd7lxjt","value":"ne@no.num","type":"EMAIL","privacy":"PRIVATE","preferredContact":false},{"id":"ck4fbarb800fd0797bck55b5m","value":"shrubberies","type":"TWITTER","privacy":"PUBLIC","preferredContact":true}],"qrcodes":[{"id":"ck4et6fu6003p0746qyvsj20p","label":"Default","scans":0}]}}}"##.data(using: .utf8)!

let heUserID = "ck4eik11p00550786r8wxoxcw"
let neUserID = "ck4et6eyv00390746s87sniwq"
let heQRCodeID = "ck4el1osu00cj0786xjugz4ig"
let geUserID = "ck4f11dt200080774s2l6yrva"
