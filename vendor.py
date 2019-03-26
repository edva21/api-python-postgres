#!/usr/bin/python
from flask import Flask
from flask_restful import Api, Resource, reqparse
import psycopg2
import json
from config import config

app = Flask(__name__)
api = Api(app)

users = [
    {
        "name": "Nicholas",
        "age": 42,
        "occupation": "Network Engineer"
    },
    {
        "name": "Elvin",
        "age": 32,
        "occupation": "Doctor"
    },
    {
        "name": "Jass",
        "age": 22,
        "occupation": "Web Developer"
    }
]

class Vendor(Resource):
    def get(self, vendor_id):
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a cursor object for execution
        cur = conn.cursor()
        # another way to call a stored procedure
        # cur.execute("SELECT * FROM get_parts_by_vendor( %s); ",(vendor_id,))
        cur.callproc('get_vendor', vendor_id)
        # process the result set
        row = cur.fetchone()
        results = []
        columns = ('vendor_id', 'vendor_name');
        while row is not None:
            results.append(dict(zip(columns,row)))
            row = cur.fetchone()
        # close the communication with the PostgreSQL database server
        cur.close()
        return results,200
    def post(self, vendor_id):
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a cursor object for execution
        cur = conn.cursor()
        # another way to call a stored procedure
        # cur.execute("SELECT * FROM get_parts_by_vendor( %s); ",(vendor_id,))
        parser = reqparse.RequestParser()
        parser.add_argument("vendor_name")
        args = parser.parse_args()
        cur.callproc('update_vendor', (vendor_id,args["vendor_name"]))

        vendors=[]

        vendor = {
            "vendor_name": args["vendor_name"],
            "vendor_id": vendor_id,
        }
        vendors.append(vendor)
        return vendor, 202

    def put(self):
         # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a cursor object for execution
        cur = conn.cursor()
        # another way to call a stored procedure
        # cur.execute("SELECT * FROM get_parts_by_vendor( %s); ",(vendor_id,))
        parser = reqparse.RequestParser()
        parser.add_argument("vendor_name")
        args = parser.parse_args()
        cur.callproc('create_vendor', (args["vendor_name"]))

        vendors=[]

        vendor = {
            "vendor_name": args["vendor_name"],
        }
        vendors.append(vendor)
        return vendor, 201

    def delete(self, vendor_id):
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a cursor object for execution
        cur = conn.cursor()
        # another way to call a stored procedure
        # cur.execute("SELECT * FROM get_parts_by_vendor( %s); ",(vendor_id,))
        cur.callproc('delete_vendor', vendor_id)
        # process the result set
        vendor = {
            "vendor_id": vendor_id,
        }
        # close the communication with the PostgreSQL database server
        cur.close()
        return vendor,202
      
api.add_resource(Vendor, "/vendor/<string:vendor_id>")

app.run(debug=True)
