// View Declaration for courses
// This interfaces with the client-side model CourseView
// 

const data = {
  courses: []
}

const methods = {

}

// const on_create = () => {
//   let view = this
//   console.log("Initializing Course View")
//   CourseView.index()
//     .then((response) => {
//       console.log(response.result.result)
//       console.log(view)
//       view.courses = response.result.result
//     })
// }

const course_view = new Vue({
  el: "#course_index",
  data: data,
  methods: methods,
  created() {
    let view = this
    console.log("Initializing Course View")
    CourseView.index()
      .then((response) => {
        console.log(response.result.result)
        console.log(view)
        view.courses = response.result.result
      }, this)
    }
})