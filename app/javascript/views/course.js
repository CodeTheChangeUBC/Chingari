import Vue from 'vue/dist/vue.esm'
import AsyncComputed from 'vue-async-computed'
import _ from 'lodash';
import CourseModel from '../models/course'
import { ControlList, ControlView, ControlForm } from '../components/control_components'
import { CourseRenderLarge, CourseRenderSmall, DocumentRender, EmbedRender, TextRender } from '../components/course'
import { wait, copy_to_clipboard, capitalize } from '../layout/utility'

/*--------------------------------------------
------------ Course Application ------------
---------------------------------------------*/
// API limits
// Pagination and filtering

export function CourseApp(mount, notifications) {
  return new Vue({
    el: mount,
    data: {
      page: 1,
      max_page_number: 20,
      search: "",
      validation_errors: {},
      can_page: undefined,
      can_create: undefined,
      can_read: {},
      can_update: {},
      can_delete: {},
      path: preload_data.subpath,
      schema: undefined,
      model: undefined,
      viewing_mode: undefined,
      attachments:[]
    },
    watch: {
      search(newSearch, oldSearch) {
        this.search_index()
      }
    },
    computed: {
      authenticity_token() {
        return document.querySelector('meta[name="csrf-token"]').content
      }
    },
    methods: {
      upload_document () {
        const data = document.getElementById('document-upload-form')
        const form = new FormData(data);
        this.create_attachment(this.model.id, form)
      },
      search_index() {
        _.debounce(() => {
        if (this.search.match(/^\s+$/) == null) {
            this.page = 1
            this.index_items()
          }
        }, 100)()
      },
      capitalize(string) {
        return capitalize(string).replace(/_/g, ' ')
      },
      transition(api_promise, success_viewing_mode) {
        const last_state = this.viewing_mode
        const should_transition = this.viewing_mode !== success_viewing_mode
        let loading_screen = undefined
        if (should_transition) {
          this.viewing_mode = "blank"
          loading_screen = setTimeout(() => { this.viewing_mode = "load" }, 100)
        }
        Vue.set(this, "validation_errors", {})
        return api_promise.then(this.success).catch(this.error)
          .then(() => {
            if (success_viewing_mode === 'index') {
              this.test_page()
            }
          })
          .then(() => {
            if (should_transition) {
              clearTimeout(loading_screen)
              this.viewing_mode = "blank"
              return wait(100)
            } else {
              return
            }
          }).catch((error) => {
            clearTimeout(loading_screen)
            if (should_transition) {
              clearTimeout(loading_screen)
              this.viewing_mode = last_state
              throw error
            } else {
              throw error
            }
          })
          .then(() => { this.viewing_mode = success_viewing_mode })
      },
      success(response) {
        if (response.result !== undefined) {
          if (response.result.constructor === Array) { 
            let promises = []
            promises.push(this.test_create())
            response.result.forEach( (item) => {
              if (item.id !== undefined && item.id !== null) {
                promises.push(this.test_read(item.id))
                // promises.push(this.test_update(item.id)) // can defer
                // promises.push(this.test_delete(item.id)) // can defer
              }           
            })
            return Promise.all(promises).then(() => {
              this.model = response.result
              if (response.schema !== undefined && response.schema.constructor === Object) {
                this.schema = response.schema
              }
            })
          } else if (response.result.constructor === Object) {
            let promises = []
            const item = response.result
            if (item.id !== undefined && item.id !== null) {
              promises.push(this.test_update(item.id))
              promises.push(this.test_delete(item.id))
            }

            if (this.viewing_mode !== 'new') {
              promises.push(this.list_attachments(item.id))
            }

            return Promise.all(promises).then(() => {
              this.model = response.result
              if (response.schema !== undefined && response.schema.constructor === Object) {
                this.schema = response.schema
              }
            })
          } else if (response.result.constructor === String) {
            setTimeout(() => notifications.notify(response.result), 100)
          }
        }
        return
      },
      error(response) {
        console.log(response)
        if (response.status === 400 && response.result.constructor === Object) {
          for (const property in response.result) {
            const errors = response.result[property]
            Vue.set(this.validation_errors, property, errors)
            for (const error of errors) {
              setTimeout(() => notifications.error(capitalize(property) + " " + error), 100)
            }
          }
        } else {
          setTimeout(() => notifications.error(response.result), 100)
        }
        // Need to throw an error to signal roll-back in transition
        throw (new Error(JSON.stringify(response)))
      },
      paramsJSON(params) {
        return JSON.parse(JSON.stringify(params))
      },
      changed(new_model) {
        this.model = new_model
      },
      copylink(id) {
        copy_to_clipboard(window.location.host + "/community/" + id)
        notifications.notify("The course link has been copied to your clipboard")
      },
      index_items() { return this.transition(CourseModel.index({ page: this.page, search: this.search }), "index") },
      show_item(id) { return this.transition(CourseModel.show(id), "show") },
      new_item() { return this.transition(CourseModel.new(), "new") },
      edit_item(id) { return this.transition(CourseModel.edit(id), "edit") },
      create_item(params) { return this.transition(CourseModel.create(this.paramsJSON(params)), "blank").then(() => { this.index_items() }) },
      update_item(id, params) { return this.transition(CourseModel.update(id, this.paramsJSON(params)), "blank").then(() => { this.index_items() }) },
      delete_item(id) { return this.transition(CourseModel.delete(id), "blank").then(() => { this.index_items() }) },
      test_create() {
        return CourseModel.new().then(() => this.can_create = true).catch(() => this.can_create = false)
      },
      test_read(id) {
        return CourseModel.show(id).then(() => Vue.set(this.can_read, id, true)).catch(() => Vue.set(this.can_read, id, false))
      },
      test_update(id) {
        return CourseModel.edit(id).then(() => Vue.set(this.can_update, id, true)).catch(() => Vue.set(this.can_update, id, false))
      },
      test_delete(id) {
        return CourseModel.test_delete(id).then(() => Vue.set(this.can_delete, id, true)).catch(() => Vue.set(this.can_delete, id, false))     
      },
      test_page() {
        if (this.page < this.max_page_number) {
          CourseModel.index({ page: this.page + 1, search: this.search }).then((response) => {
            if (response.result.constructor === Array && response.result.length > 0) {
              this.can_page = true
            } else {
              this.can_page = false
            }
          })
        } else {
          this.can_page = false
        }
      },
      next_page() {
        if (this.page < this.max_page_number) {
          this.page += 1
          this.index_items()
        }
      },
      previous_page() {
        if (this.page > 1) {
          this.page -= 1
          this.index_items()
        }
      },
      list_attachments(course_id) {
        CourseModel.index_attachments(course_id)
          .then((response) => {
            this.attachments = response.result
          })
          .catch(() => {
            notifications.error(response.result)
          })
      },
      create_attachment(course_id, attachment) {
        CourseModel.create_attachment(course_id, attachment)
          .then((response) => {
            this.list_attachments(course_id)
          })
          .catch((response) => {
            notifications.error(response.result)
          })
      },
      update_attachment(course_id, attachment_id, attachment) {
        CourseModel.update_attachment(course_id, attachment_id, attachment)
          .then((response) => {
            this.list_attachments(course_id)
          })
          .catch((response) => {
            notifications.error(response.result)
          })
      },
      delete_attachment(course_id, attachment_type, attachment_id) {
        CourseModel.delete_attachment(course_id, attachment_type, attachment_id)
          .then((response) => {
            this.list_attachments(course_id)
          })
          .catch((response) => {
            notifications.error(response.result)
          })
      },
    },
    created() {
      if (this.path.match(/^\d+$/) !== null) {
        let id = this.path.match(/^\d+$/)[0]
        this.show_item(id)
      } else {
        this.index_items()
      }
    },
    template: `
              <div style="min-height: 300px"  v-if="viewing_mode !== undefined">
                <transition name="fade-in-out">

                  <control-list 
                    v-if="viewing_mode === 'index'">
                    <div slot="controls" class="row">

                      <div class="col-md-4 col-sm-6" style="text-align:center;margin-top:10px;margin-bottom:10px">
                        <button class="button orange-button" 
                          slot="controls"
                          v-if="can_create === true"
                          v-on:click="new_item()">
                          New Course
                        </button>
                      </div>

                      <div class="col-md-4 col-sm-6" style="text-align:center;margin-top:10px;margin-bottom:10px">
                        <div class="input-group">
                          <div class="input-group-prepend">
                            <div class="input-group-text"><i class="fa fa-search"></i></div>
                          </div>
                          <input v-model="search" 
                            class="form-control" type="search" placeholder="search">
                        </div>
                      </div>

                      <div class="col-md-4 col-sm-12" style="text-align:center;margin-top:10px;margin-bottom:10px">
                        <div class="btn-group" role="group">
                          <button 
                            v-if="page > 1"
                            v-on:click="previous_page()"
                            type="button" class="btn btn-secondary">Previous</button>
                          <button type="button" class="btn btn-secondary" disabled>Page {{ page }}</button>
                          <button
                             v-if="can_page"
                             v-on:click="next_page()"
                            type="button" class="btn btn-secondary">Next</button>
                        </div>
                      </div>

                    </div>

                    <course-render-small
                      slot="preview"
                      v-if="model.length > 0"
                      v-for="item in model" 
                      v-bind:key="item.id"
                      v-bind:schema="schema" 
                      v-bind:item="item">

                      <button
                        slot="controls"
                        v-if="can_read[item.id] === true"
                        v-on:click="show_item(item.id)"
                        class="button blue-button" >
                        View
                      </button>
                    </course-render-small>
                  
                    <div 
                      v-if="model.length === 0"
                      slot="preview"
                      class="title" style="text-align:center;padding:50px;">
                      No Content
                    </div>

                  </control-list>







                  <control-view 
                    v-if="viewing_mode === 'show'">

                    <course-render-large
                      slot="view"
                      v-bind:schema="schema"
                      v-bind:item="model">

                      <div slot="controls">
                        <button
                          class="button blue-button"
                          v-on:click="index_items()">
                          Back
                        </button>
                        <button
                          class="button blue-button"
                          v-on:click="copylink(model.id)">
                          Share
                        </button>
                        <button class="button orange-button"
                          v-if="can_update[model.id] === true"
                          v-on:click="edit_item(model.id)">
                          Edit
                        </button>

                      </div>

                      <div slot="attachments">
                        <span v-for="(attachment, index) in attachments">
                          <document-render
                            v-if="attachment.type === 'Document'"
                            v-bind:item="attachment">
                          </document-render>
                          <embed-render
                            v-if="attachment.type === 'Embed'"
                            v-bind:item="attachment">
                          </embed-render>
                          <text-render
                            v-if="attachment.type === 'Text'"
                            v-bind:item="attachment">
                          </text-render>
                        </span>
                      </div>

                    </course-render-large>
                    
                  </control-view>







                  <control-form 
                    v-if="viewing_mode === 'new' || viewing_mode === 'edit'" 
                    v-bind:schema="schema" 
                    v-bind:item="model" 
                    v-bind:mode="viewing_mode"
                    v-bind:errors="validation_errors"
                    v-on:changed="changed">

                    <course-render-large
                      slot="preview"
                      v-bind:schema="schema"
                      v-bind:item="model">

                      <div v-if="viewing_mode === 'edit'" slot="attachments">
                        <span v-for="(attachment, index) in attachments">
                          <document-render
                            v-if="attachment.type === 'Document'"
                            v-bind:item="attachment">

                            <span slot="controls"
                              v-if="can_update[model.id] === true">

                              <button
                                class="button orange-button"
                                v-if="index >= 1"
                                v-on:click="update_attachment(model.id, attachment.id, { type: attachment.type, display_index: attachment.display_index - 1 })">
                                Move Up
                              </button>

                              <button
                                class="button orange-button"
                                v-if="index <= attachments.length"
                                v-on:click="update_attachment(model.id, attachment.id, { type: attachment.type, display_index: attachment.display_index + 1 })">
                                Move Down
                              </button>

                              <button class="button orange-button"
                                v-on:click="delete_attachment(model.id, attachment.type.toLowerCase() + 's', attachment.id).then(() => list_attachments())">
                                Delete
                              </button>

                            </span>    
                          </document-render>


                          <embed-render
                            v-if="attachment.type === 'Embed'"
                            v-bind:item="attachment">

                            <span slot="controls"
                              v-if="can_update[model.id] === true">

                              <button
                                class="button orange-button"
                                v-if="index >= 1"
                                v-on:click="update_attachment(model.id, attachment.id, { type: attachment.type, display_index: attachment.display_index - 1 })">
                                Move Up
                              </button>

                              <button
                                class="button orange-button"
                                v-if="index <= attachments.length"
                                v-on:click="update_attachment(model.id, attachment.id, { type: attachment.type, display_index: attachment.display_index + 1 })">
                                Move Down
                              </button>

                              <button class="button orange-button"
                                v-on:click="delete_attachment(model.id, attachment.type.toLowerCase() + 's', attachment.id).then(() => list_attachments())">
                                Delete
                              </button>

                            </span>
                          </embed-render>


                          <text-render
                            v-if="attachment.type === 'Text'"
                            v-bind:item="attachment">
                            <span slot="controls"
                              v-if="can_update[model.id] === true">

                              <button
                                class="button orange-button"
                                v-if="index >= 1"
                                v-on:click="update_attachment(model.id, attachment.id, { type: attachment.type, display_index: attachment.display_index - 1 }).then(() => list_attachments())">
                                Move Up
                              </button>

                              <button
                                class="button orange-button"
                                v-if="index <= attachments.length"
                                v-on:click="update_attachment(model.id, attachment.id, { type: attachment.type, display_index: attachment.display_index + 1 }).then(() => list_attachments())">
                                Move Down
                              </button>

                              <button class="button orange-button"
                                v-on:click="delete_attachment(model.id, attachment.type.toLowerCase() + 's', attachment.id).then(() => list_attachments())">
                                Delete
                              </button>

                            </span>
                          </text-render>
                          
                        </span>
                      </div>

                    </course-render-large>


                    

                    <div slot="controls">
                      <span v-if="viewing_mode === 'new'">
                        <button class="button blue-button" 
                          v-on:click="index_items()">
                          Cancel
                        </button>
                        <button class="button orange-button"
                          v-if="can_create === true" 
                          v-on:click="create_item(model)">
                          Create
                        </button>
                      </span>

                      <span v-if="viewing_mode === 'edit'">
                        <button class="button blue-button" 
                          v-on:click="show_item(model.id)">
                          Cancel
                        </button>
                        <button class="button orange-button"
                          v-if="can_update[model.id] === true"
                          v-on:click="update_item(model.id, model)">
                          Save
                        </button>
                        <button class="button orange-button"
                          v-if="can_delete[model.id] === true"
                          v-on:click="delete_item(model.id)">
                          Delete
                        </button>

                        <div>
                          <form id="document-upload-form">
                            <input name="authenticity_token" v-bind:value="authenticity_token" type="hidden">
                            <input name="attachment[course_id]" v-bind:value="model.id" type="hidden">
                            <input name="attachment[type]" v-bind:value="'Document'" type="hidden">
                            <label for="file-upload">
                                <div class="button orange-button"><i class="fa fa-file fa-padded"></i>Attach</div>
                            </label>
                            <input id="file-upload" name="attachment[file]" v-on:change="upload_document" type="file" style="display:none">
                          </form>
                        </div>

                      </span>
                      
                    </div>

                  </control-form>

                  <div class="loading text-center"
                    v-if="viewing_mode === 'load'">
                    <i class="fa fa-spinner fa-spin-fast fa-lg"></i>
                  </div>

                </transition>
              </div>
              `
  })
}