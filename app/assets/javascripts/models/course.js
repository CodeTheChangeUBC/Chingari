class CourseModel {
    // If any of these get an error code, the promise should reject with <status: error_code, result: explanation>

    static parse_response(response) {
        response.status = response.status
        return response
    }

    // .index() => Promise<status: success_code, result: existing_courses>
    static index() {
        return new Promise(function(resolve, reject){
            let url = "/courses";
            $.ajax({
                url: url,
                type: 'GET',
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
            });
        })
    }

    static drafts() {
        return new Promise(function (resolve, reject) {
            let url = "/courses/drafts";
            $.ajax({
                url: url,
                type: 'GET',
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
            });
        })
    }    

    static review() {
        return new Promise(function (resolve, reject) {
            let url = "/courses/review";
            $.ajax({
                url: url,
                type: 'GET',
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
            });
        })
    }    

    static published() {
        return new Promise(function (resolve, reject) {
            let url = "/courses/published";
            $.ajax({
                url: url,
                type: 'GET',
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
            });
        })
    }

    // .show(id) => Promise<status: success_code, result: existing_course>
    static show(id) {
        return new Promise(function(resolve, reject){
            let url = "/courses/"+id;
            $.ajax({
                url: url,
                type: 'GET',
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
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
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
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
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
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
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
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
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
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
                success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
                error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
            });
        })
    }
}