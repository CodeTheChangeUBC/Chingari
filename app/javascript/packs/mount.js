// Use this file for mounting Vue applications
// Your Vue app/applet does not run until it is mounted
// This gets loaded at the end of the document body

// vue-loader is currently broken and the Vue team isn't being very helpful about supporting it
// we're going stick to declaraing the following component declaration as a work-around
//  - JS code for component registration go under app/javascript/components/*.js (or .ts)
//  - JS code for API modelling go under app/javascript/models/*.js (or .ts)
//  - stylesheets  go under app/assets/stylesheets/**/*.scss
//  - templates: declare your templates as `strings` as part of the component registration

// How we would import single-file .vue components *if vue-loader gets fixed
// import App from '../components/app.vue'

// Import all local dependencies
import AnchorScroller from '../layout/anchor_scroller'

// AnchorScroller Initialization
//    Overrides native anchor behaviour to give a smooth scroll-to effect
document.addEventListener('DOMContentLoaded', () => {
  AnchorScroller.scrollToCurrentAnchor(200, 500)
  // Block anchor-jumps when the destination is on current page
  $("a").click(AnchorScroller.overrideAnchorClick);
});

import { Notifications } from '../views/notifications'
import { CourseApp } from '../views/course'

window.addEventListener('DOMContentLoaded', () => {
  let mount_id, mount, notifications;

// Notifications:
// Usage:
//   Notifications.notify("my message")
//   Notifications.error("my error")
//   Notifications.dismiss(id)
  mount_id = "notifications"
  mount = document.getElementById(mount_id)
  if (mount !== null) {
    // This makes Notifications accessible by the window
    notifications = Notifications(mount)
    console.log("Notifications Mounted")
  }

  // CourseApp:
  //    Vue App for manipulating courses
  mount_id = "course-app"
  mount = document.getElementById(mount_id)
  if (mount !== null) {
    // This makes Notifications accessible by the window
    window.Notifications = CourseApp(mount, notifications)
    console.log("CourseApp Mounted")
  }
})






























// // Turbolinks initial-dom-loaded
// window.addEventListener('load', () => {
//   AnchorScroller.scrollToCurrentAnchor(200, 500)

//   // Block anchor-jumps when the destination is on current page
//   $("a").click(AnchorScroller.overrideAnchorClick);
// });

// // Turbolink cached-page
// $(document).on("turbolinks:visit", () => {
//   AnchorScroller.scrollToCurrentAnchor(200, 500)
// });



// Below are other set-ups for mounting

/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue/dist/vue.esm' // 'vue'
// import App from '../components/app.vue'

// document.addEventListener('DOMContentLoaded', () => {
//   const el = document.body.appendChild(document.createElement('hello'))
//   const app = new Vue({
//     el,
//     render: h => h(App)
//   })

//   console.log(app)
// })


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:

// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>

// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../components/app.vue'

// document.addEventListener('DOMContentLoaded', () => {
//   const mount = document.getElementById("app")
//   if (mount !== null) {
//     const app = new Vue({
//       el: 'body',
//       data: {
//         message: "Can you say hello?"
//       },
//       components: { App }
//     })
//   }
// })

//
//
// If the using turbolinks, install 'vue-turbolinks':
//
// yarn add 'vue-turbolinks'
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks';
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
