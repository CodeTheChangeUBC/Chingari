class CourseView {
    // If any of these get an error code, the promise should reject with <status: error_code, result: explanation>

    // .index() => Promise<status: success_code, result: existing_courses>
    static index() {
        return new Promise(function(resolve, reject){
            let url = "/courses"
            $.get(url, function(data, status, xobj){
                if (xobj.status === 200) {
                    resolve({"status":xobj.status, "result":data});
                }
                else {
                    reject({"status":xobj.status, "result":data});
                }
            });
        })
    }

    // .get(id) => Promise<status: success_code, result: existing_course>
    static get(id) {
        return new Promise(function(resolve, reject){
            let url = "/courses/"+id
            $.get(url, function(data, status, xobj){
                if (xobj.status === 200) {
                    resolve({"status":xobj.status, "result":data});
                }
                else {
                    reject({"status":xobj.status, "result":data});
                }
            });
        })
    }
}

// .new() => Promise<status: success_code, result: new_course, schema: course_schema>
// .edit(id) => Promise<status: success_code, result: existing_course, schema: course_schema>
// .create(<form_params>) => Promise<status: success_code, result: existing_course>]
// .update(id, <form_params>) => Promise<status: success_code, result: existing_course>
// .delete(id) => Promise<status: success_code, result: message>

// create and update passes the new/edited course as the <form_params> object. The renderer should know how to handle filling in the data based on the schema received from the server.