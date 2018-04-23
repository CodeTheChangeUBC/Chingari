class CourseView {
    // If any of these get an error code, the promise should reject with <status: error_code, result: explanation>

    // .index() => Promise<status: success_code, result: existing_courses>
    static index() {
        return new Promise(function(resolve, reject){
            let url = "/courses";
            $.ajax({
                url: url,
                type: 'GET',
                success: function(data, status, xobj){
                    resolve({status: xobj.status, result: xobj.responseJSON.result});
                },
                error: function(data, status, xobj){
                    reject({status: data.status, result: data.responseJSON.result});
                }
            });
        })
    }

    // .get(id) => Promise<status: success_code, result: existing_course>
    static get(id) {
        return new Promise(function(resolve, reject){
            let url = "/courses/"+id;
            $.ajax({
                url: url,
                type: 'GET',
                success: function (data, status, xobj) {
                    resolve({ status: xobj.status, result: xobj.responseJSON.result });
                },
                error: function (data, status, xobj) {
                    reject({ status: data.status, result: data.responseJSON.result });
                }
            });
        })
    }

    // .new() => Promise<status: success_code, result: new_course, schema: course_schema>
    static new() {
        return new Promise(function(resolve, reject){
            let url = "/courses/new";
            $.ajax({
                url: url,
                type: 'GET',
                success: function (data, status, xobj) {
                    resolve({ status: xobj.status, result: xobj.responseJSON.result, schema:data.responseJSON.result });
                },
                error: function (data, status, xobj) {
                    reject({ status: data.status, result: data.responseJSON.result });
                }
            });
        })
    }

    // .edit(id) => Promise<status: success_code, result: existing_course, schema: course_schema>
    static edit(id) {
        return new Promise(function(resolve, reject){
            let url = "/courses/"+id+"/edit";
            $.ajax({
                url: url,
                type: 'GET',
                success: function (data, status, xobj) {
                    resolve({ status: xobj.status, result: xobj.responseJSON.result, schema:data.responseJSON.result });
                },
                error: function (data, status, xobj) {
                    reject({ status: data.status, result: data.responseJSON.result });
                }
            });
        })
    }

    // .create(<form_params>) => Promise<status: success_code, result: existing_course>]
    // create and update passes the new/edited course as the <form_params> object. The renderer should know how to handle filling in the data based on the schema received from the server.
    static create(params) {
        return new Promise(function(resolve, reject){
            let url = "/courses";
            $.ajax({
                url: url,
                type: 'POST',
                data: params,
                success: function (data, status, xobj) {
                    resolve({ status: xobj.status, result: xobj.responseJSON.result });
                },
                error: function (data, status, xobj) {
                    reject({ status: data.status, result: data.responseJSON.result });
                }
            });
        })
    }

    // .update(id, <form_params>) => Promise<status: success_code, result: existing_course>
    // create and update passes the new/edited course as the <form_params> object. The renderer should know how to handle filling in the data based on the schema received from the server.
    static update(id, params) {
        return new Promise(function(resolve, reject){
            let url = "/courses/"+id;
            $.ajax({
                url: url,
                type: 'PUT',
                data: params,
                success: function (data, status, xobj) {
                    resolve({ status: xobj.status, result: xobj.responseJSON.result });
                },
                error: function (data, status, xobj) {
                    reject({ status: data.status, result: data.responseJSON.result });
                }
            });
        })
    }

    // .delete(id) => Promise<status: success_code, result: message>
    static delete(id) {
        return new Promise(function(resolve, reject){
            let url = "/courses/"+id;
            $.ajax({
                url: url,
                type: 'DELETE',
                success: function (data, status, xobj) {
                    resolve({ status: xobj.status, result: xobj.responseJSON.result });
                },
                error: function (data, status, xobj) {
                    reject({ status: data.status, result: data.responseJSON.result });
                }
            });
        })
    }
}