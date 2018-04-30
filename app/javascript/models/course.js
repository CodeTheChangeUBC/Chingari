import * as $ from "jquery";
export default class CourseModel {
  // If any of these get an error code, the promise should reject with <status: error_code, result: explanation>

  static token() {
    return document.querySelector('meta[name="csrf-token"]').content
  }

  static parse_response(response) {
    let new_response;
    if (response.responseJSON === undefined) {
      console.log("Could not parse the following repsonse:")
      console.log(response)
      new_response =  { status: 500, result: "Internal Error" }
    } else {
      new_response = response.responseJSON
      new_response.status = response.status
    }
    return new_response
  }

  static send_get(url) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: url,
        type: 'GET',
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  static send_post(url, data) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: url,
        type: 'POST',
        data: { course: data, authenticity_token: CourseModel.token() },
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  static send_put(url, data) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: url,
        type: 'PUT',
        data: { course: data, authenticity_token: CourseModel.token() },
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  static send_delete(url) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: url,
        type: 'DELETE',
        data: { authenticity_token: CourseModel.token() },
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  // url = /courses/:course_id/attachments
  // response = { result: [ { id: 3, type: 'Document', title: '' } ] }
  static index_attachments(course_id) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: "/courses/" + course_id + "/attachments",
        type: 'GET',
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  // url = /courses/:course_id/attachments
  // resquest = { attachment: { type: 'Document', title: '' } }
  static create_attachment(course_id, data) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: "/courses/" + course_id + "/attachments",
        type: 'POST',
        processData: false,
        contentType: false,
        data: data,
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  // url = /courses/:course_id/attachments/:attachment_id
  // resquest = { attachment: { id: 3, type: 'Document', title: '' } }
  static update_attachment(course_id, attachment_id, data) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: "/courses/" + course_id + "/attachments/" + attachment_id,
        type: 'PUT',
        data: { attachment: data, authenticity_token: CourseModel.token() },
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  // url = /courses/:course_id/attachments/:attachment_id
  static delete_attachment(course_id, attachment_type, attachment_id) {
    return new Promise(function (resolve, reject) {
      $.ajax({
        url: "/courses/" + course_id + "/attachments/" + attachment_type + "/" + attachment_id,
        type: 'DELETE',
        data: { authenticity_token: CourseModel.token() },
        success(data, status, xobj) { resolve(CourseModel.parse_response(xobj)) },
        error(data, status, xobj) { reject(CourseModel.parse_response(data)) }
      });
    })
  }

  // .index() => Promise<status: success_code, result: existing_courses>
  static index(query_params) {
    let url = "/courses"
    if (query_params !== undefined) {
      let params = []
      for (const key in query_params) {
        params.push(key + "=" + query_params[key])
      }
      url = url + "?" + params.join("&")
    }
    return CourseModel.send_get(url)
  }

  // .show(id) => Promise<status: success_code, result: existing_course>
  static show(id) {
    return CourseModel.send_get("/courses/" + id)
  }

  // .new() => Promise<status: success_code, result: new_course, schema: course_schema>
  static new() {
    return CourseModel.send_get("/courses/new")
  }

  // .edit(id) => Promise<status: success_code, result: existing_course, schema: course_schema>
  static edit(id) {
    return CourseModel.send_get("/courses/" + id + "/edit")
  }

  // .create(<form_params>) => Promise<status: success_code, result: existing_course>]
  // create and update passes the new/edited course as the <form_params> object. The renderer should know how to handle filling in the data based on the schema received from the server.
  static create(params) {
    return CourseModel.send_post("/courses", params)
  }

  // .update(id, <form_params>) => Promise<status: success_code, result: existing_course>
  // create and update passes the new/edited course as the <form_params> object. The renderer should know how to handle filling in the data based on the schema received from the server.
  static update(id, params) {
    return CourseModel.send_put("/courses/" + id, params)
  }

  // .delete(id) => Promise<status: success_code, result: message>
  static delete(id) {
    return CourseModel.send_delete("/courses/" + id)
  }

  // .test_delete(id) => Promise<status: success_code, result: message>
  // This only tests to see if delete is permitted, but does not perform the deletion
  static test_delete(id) {
    return CourseModel.send_delete("/courses/" + id + "?query_only=true")
  }
}