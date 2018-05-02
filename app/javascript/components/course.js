import Vue from 'vue/dist/vue.esm'
import CourseModel from '../models/course'
import { ModelView } from '../components/control_components'

/*--------------------------------------------
------------ Course Custom Render ------------
---------------------------------------------*/

export const CourseRenderLarge = Vue.component("course-render-large", {
  props: ["schema", "item"],
  data() {
    return { authorized: undefined }
  },
  computed: {
    auto_embed_youtube() {
      let text = this.item.description
      while (this.authorized && text.match(/https\:\/\/www\.youtube\.com\/watch\?v=(\w+)/) !== null) {
        text = text.replace(/https\:\/\/www\.youtube\.com\/watch\?v=(\w+)/, 
        `
        <div class="embed-responsive embed-responsive-16by9">
          <iframe class="embed-responsive-item" width="560" height="315" 
            src = "https://www.youtube.com/embed/$1" 
            frameborder = "0" 
            allow = "autoplay; 
            encrypted - media" 
            allowfullscreen >
          </iframe >
        </div>`)
        
      }
      return text
    }
  },
  created() {
    CourseModel.send_get('/authorize/' + this.item.user_id)
      .then(() => this.authorized = true)
      .catch(() => this.authorized = false)
  },
  template: `
            <div class="material-shadow course-render-large" style="padding: 10px 10px 30px 10px">

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
              <p class="text" v-if="authorized">
                <raw-render
                  v-bind:string="auto_embed_youtube"
                  v-bind:placeholder="'Blank Description'"
                  >
                </raw-render>
              </p>
              <p class="text" v-else>
                <string-render
                  v-bind:string="auto_embed_youtube"
                  v-bind:placeholder="'Blank Description'"
                  >
                </string-render>
              </p>

              <slot name="attachments"></slot>

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
            <div>
            <div style="margin-top:5px;margin-bottom:5px;">

              <span class="text" v-if="item.file.url.match(/.+\.gif$/) !== null || item.file.url.match(/.+\.jpeg$/) !== null || item.file.url.match(/.+\.jpg$/) !== null || item.file.url.match(/.+\.png$/) !== null ">
                <div v-bind:style="'height:20vmax;width:100%;background-image: url(' + item.file.url + ');background-attachment: scroll;background-position: center center;background-repeat: no-repeat;background-size: contain;'">
                </div>
              </span>

              <span style="padding:5px 5px 5px 30px" class="subtitle font-weight-bold" v-else>
                <a v-bind:href="item.file.url" download class="light-blue-theme">
                  <string-render 
                    v-bind:string="item.title"
                    v-bind:placeholder="'Blank Title'"
                    >
                  </string-render>
                </a>
              </span>
              <br>
              <span style="text-align:right">
                  <slot name="controls"></slot>
              </span>
            </div>
            </div>
            `
})

export const EmbedRender = Vue.component("embed-render", {
  props: ["schema", "item"],
  template: `
            <div>
            <div class="course-render-small col-sm-12">
              <div class="material-shadow" style="margin: 5px 0px 5px 0px; padding: 10px;">
              
                <p class="text">
                  <raw-render 
                    v-bind:string="item.content"
                    v-bind:placeholder="'No content'"
                    >
                  </raw-render>
                </p>
                <span style="text-align:right">
                    <slot name="controls"></slot>
                </span>
              </div>
            </div>
            </div>
            `
})


export const TextRender = Vue.component("text-render", {
  props: ["schema", "item"],
  template: `
            <div>
            <div class="course-render-small col-sm-12">
              <div class="material-shadow" style="margin: 5px 0px 5px 0px; padding: 10px;">
              
                <p class="text">
                  <string-render 
                    v-bind:string="item.content"
                    v-bind:placeholder="'No Content'"
                    >
                  </string-render>
                </p>

                <span style="text-align:right">
                    <slot name="controls"></slot>
                </span>
              </div>
            </div>
            </div>
            `
})
