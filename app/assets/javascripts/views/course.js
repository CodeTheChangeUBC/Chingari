// View Declaration for courses
// This interfaces with the client-side model CourseView
// 

const data = {
  errors: [],
  courses: [],
  course: undefined
}

const methods = {

}

const course_view = new Vue({
  el: "#course_view",
  data: data,
  methods: {
    index() {
      CourseView.index()
        .then((response) => {
          this.courses = response.result
        })    
        .catch((response) => { Notifications.error(response.result) })  
    },
    get(id) {

    }
  },
  created() {
    console.log("Initializing Course View")
    this.index();
  }
})