import Vue from 'vue/dist/vue.esm'

/*--------------------------------------------
------------ Course Custom Render ------------
---------------------------------------------*/

export const CourseRenderLarge = Vue.component("course-render-large", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-large">
              <p class="title">
                <string-render 
                  v-bind:string="item.title"
                  v-bind:placeholder="'Blank Title'"
                  >
                </string-render>
              </p>
              <p class="text">
                <string-render
                  v-bind:string="item.description"
                  v-bind:placeholder="'Blank Description'"
                  >
                </string-render>
              </p>
            </div>
            `
})

export const CourseRenderSmall = Vue.component("course-render-small", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-small col-lg-4 col-md-6 col-sm-12">
              <p class="title">
                <string-render 
                  v-bind:string="item.title"
                  v-bind:placeholder="'Blank Title'"
                  >
                </string-render>
              </p>
              <slot name="controls"></slot>
            </div>
            `
})

