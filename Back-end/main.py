import json, firebase_admin, functions_framework
from flask import Flask, request, jsonify
from firebase_admin import credentials
from firebase_admin import firestore
from flask_cors import CORS
import datetime
import pytz

# Use a service account.
cred = credentials.Certificate('key.json')

app = firebase_admin.initialize_app(cred)

db = firestore.client()

app = Flask(__name__)


# Create Profile


# Create Student Profile (Id, name, email, DOB, yeargroup, major, campus residence)
# @app.route('/student', methods=['POST'])
def create_profile():
    new_record = json.loads(request.data)
    collection_name = "students"
    document_name = new_record['email']
    doc_ref = db.collection(collection_name).document(document_name)
    doc = doc_ref.get()

    if doc.exists:
        return jsonify("Data already exists"), 409
    else:
        doc_ref.set(new_record)
        return jsonify("Added " + document_name), 201

# Edit Student Profile
# @app.route('/student', methods=['PUT'])
def edit_profile():
    record = json.loads(request.data)
    collection_name = "students"
    document_name = record['email']
    doc_ref = db.collection(collection_name).document(document_name)
    doc = doc_ref.get()

    if doc.exists:
        new_record = {}
        for key, value in record.items():
            if value != "":
                new_record[key] = value

        doc_ref.update(new_record)
        return "Edited", 200
    else:
        return "Profile does not exist", 404
    
# @app.route('/student', methods=['GET'])
def view_profile():
    document_id = request.args.get('email')
    collection_name = "students"
    
    doc_ref = db.collection(collection_name).document(document_id)
    doc = doc_ref.get()

    if doc.exists:
        data = doc.to_dict()
        return jsonify(data), 200
    else:
        return "Doesn't exist", 404
    
    
    
# @app.route('/post', methods=['POST'])  
def make_post():

    record = json.loads(request.data)
    email = record['email']
    
    post_collection_name = "posts"
    students_collection_name = "students"

    # Timestamp
    gmt = pytz.timezone('GMT')
    current_datetime = datetime.datetime.now(tz=gmt)
    datetime_string = current_datetime.strftime("%d-%m-%Y %H:%M:%S")

    # Adding Timestamp to record
    record["timestamp"] = datetime_string

    # Accessing database collections
    doc_ref_posts = db.collection(post_collection_name).document()
    doc_ref_students = db.collection(students_collection_name).document(email)

    doc_students = doc_ref_students.get()

    # Checks if the email given exists
    if doc_students.exists:
        doc_ref_posts.set(record)
        return "Post added", 201
    else:
        return "User does not exist", 404
    
# @app.route('/post', methods=['GET'])
def get_posts():
    request_args = request.args.get("timestamp")
    collection_name = "posts"
    doc_ref = db.collection(collection_name)

    if request_args:
        next_query = (doc_ref
                      .order_by('timestamp', direction=firestore.Query.DESCENDING)
                      .start_after({'timestamp':request_args})
                      .limit(14))

        next_batch = [doc.to_dict() for doc in next_query.stream()]
        return jsonify(next_batch)

    else:
        first_query = doc_ref.order_by('timestamp', direction=firestore.Query.DESCENDING).limit(14)
        posts = [doc.to_dict() for doc in first_query.stream()]
        return jsonify(posts)
        

@functions_framework.http
def profile(request):
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    request_json = request.get_json(silent=True)
    request_args = request.args

    if request.method == "POST" and 'email' in request_json:
        return create_profile() 
    elif request.method == "PUT" and 'email' in request_json:
        return edit_profile()
    elif request.method == "GET" and 'email' in request_args:
        return view_profile()
    else:
        return "Invalid request"
    
def post(request):
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    request_json = request.get_json(silent=True)
    request_args = request.args

    if request.method == "POST" and 'email' in request_json:
        return make_post()
    elif request.method == "GET" and 'timestamp' in request_args:
        print("Reached here")
        return get_posts()
    else:
        return "Invalid request"


        


# app.run(debug=True)