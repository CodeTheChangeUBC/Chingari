import Vue from 'vue/dist/vue.esm'
import { ModelView } from '../components/control_components'

/*--------------------------------------------
------------ Course Custom Render ------------
---------------------------------------------*/

export const CourseRenderLarge = Vue.component("course-render-large", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-large" style="padding: 10px">

               <div class="row" style="padding: 15px">
                <div class="col-sm-12">
                  <slot name="controls"></slot>
                </div>
              </div>           

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

              <div class="row" style="padding: 15px">
                <div class="col-sm-12">
                  <slot name="attachments"></slot>
                </div>
              </div>
            </div>
            `
})

export const CourseRenderSmall = Vue.component("course-render-small", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-small col-lg-4 col-md-6 col-sm-12">
              <div class="material-shadow" style="margin: 5px 0px 5px 0px; padding: 10px;">
              
                <p class="subtitle">
                  <string-render 
                    v-bind:string="item.title"
                    v-bind:placeholder="'Blank Title'"
                    >
                  </string-render>
                </p>

                <div class="row" style="padding: 15px">
                  <div class="col-sm-12">
                    <slot name="controls"></slot>
                  </div>
                </div>
              </div>
            </div>
            `
})

export const DocumentRender = Vue.component("document-render", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-small col-lg-4 col-md-6 col-sm-12">
              <div class="material-shadow" style="margin: 5px 0px 5px 0px; padding: 10px;">
              
                <p class="subtitle">
                  <string-render 
                    v-bind:string="item.title"
                    v-bind:placeholder="'Blank Title'"
                    >
                  </string-render>
                </p>

                <div class="row" style="padding: 15px">
                  <div class="col-sm-12">
                    <slot name="controls"></slot>
                  </div>
                </div>
              </div>
            </div>
            `
})

export const EmbedRender = Vue.component("embed-render", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-small col-lg-4 col-md-6 col-sm-12">
              <div class="material-shadow" style="margin: 5px 0px 5px 0px; padding: 10px;">
              
                <p class="subtitle">
                  <raw-render 
                    v-bind:string="item.content"
                    v-bind:placeholder="'No content'"
                    >
                  </raw-render>
                </p>

                <div class="row" style="padding: 15px">
                  <div class="col-sm-12">
                    <slot name="controls"></slot>
                  </div>
                </div>
              </div>
            </div>
            `
})

export const TextRender = Vue.component("text-render", {
  props: ["schema", "item"],
  template: `
            <div class="course-render-small col-lg-4 col-md-6 col-sm-12">
              <div class="material-shadow" style="margin: 5px 0px 5px 0px; padding: 10px;">
              
                <p class="subtitle">
                  <string-render 
                    v-bind:string="item.content"
                    v-bind:placeholder="'No Content'"
                    >
                  </string-render>
                </p>

                <div class="row" style="padding: 15px">
                  <div class="col-sm-12">
                    <slot name="controls"></slot>
                  </div>
                </div>
              </div>
            </div>
            `
})