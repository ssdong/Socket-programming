#!/bin/bash

#Number of parameters: 4
#Parameter:
#  $1=server
#  $2=neg_port
#  $3=req_code
#  $4=message


ruby client.rb $1 $2 $3 "$4"