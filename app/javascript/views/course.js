import Vue from 'vue/dist/vue.esm'
import AsyncComputed from 'vue-async-computed'
import CourseModel from '../models/course'
import { ControlList, ControlView, ControlForm } from '../components/control_components'
import { CourseRenderLarge, CourseRenderSmall } from '../components/course'
import { wait, copy_to_clipboard } from '../layout/utility'

/*--------------------------------------------
------------ Course Application ------------
---------------------------------------------*/

// Some work to be done:
// Dynamic render-small based on index-given schema
// Dynamic render-large based on given schema
// Pagination and filtering

export function CourseApp(mount, notifications) {
  return new Vue({
    el: mount,
    data: {
      can_create: undefined,
      can_read: {},
      can_update: {},
      can_delete: {},
      path: preload_data.subpath,
      schema: undefined,
      model: undefined,
      viewing_mode: undefined,
      permissions: undefined
    },
    methods: {
      transition(api_promise, success_viewing_mode) {
        const last_state = this.viewing_mode
        this.viewing_mode = "blank"
        const load = setTimeout(() => { this.viewing_mode = "load" }, 200)
        return api_promise.then(this.success).catch(this.error)
          .then(() => {
            clearTimeout(load)
            this.viewing_mode = "blank"
            return wait(200)
          }).catch((error) => {
            clearTimeout(load)
            this.viewing_mode = last_state
            throw error
          })
          .then(() => { this.viewing_mode = success_viewing_mode })
      },
      success(response) {
        let promises = []
        if (response.result !== undefined) {
          if (response.result.constructor === Array) { 
            this.model = response.result
            promises.push(this.test_create())
            response.result.forEach( (item) => {
              if (item.id !== undefined && item.id !== null) {
                promises.push(this.test_read(item.id))
                promises.push(this.test_update(item.id)) // can defer
                promises.push(this.test_delete(item.id)) // can defer
              }           
            })
          } else if (response.result.constructor === Object) {
            this.model = response.result
            const item = this.model
            if (item.id !== undefined && item.id !== null) {
              promises.push(this.test_read(item.id))
              promises.push(this.test_update(item.id)) // can defer
              promises.push(this.test_delete(item.id)) // can defer
            }           
          } else if (response.result.constructor === String) {
            notifications.notify(response.result)
          }
        }
        if (response.schema !== undefined && response.schema.constructor === Object) {
          this.schema = response.schema
        }
        return Promise.all(promises)
      },
      error(response) {
        notifications.error(response.result)
        console.log(response)
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
      index_items() { return this.transition(CourseModel.index(), "index") },
      show_item(id) { return this.transition(CourseModel.show(id), "show") },
      new_item() { return this.transition(CourseModel.new(), "new") },
      edit_item(id) { return this.transition(CourseModel.edit(id), "edit") },
      create_item(params) { return this.transition(CourseModel.create(this.paramsJSON(params)), "blank").then(() => { this.index() }) },
      update_item(id, params) { return this.transition(CourseModel.update(id, this.paramsJSON(params)), "blank").then(() => { this.index() }) },
      delete_item(id) { return this.transition(CourseModel.delete(id), "blank").then(() => { this.index() }) },
      test_create() {
        this.can_create = undefined
        return CourseModel.new()
          .then(() => { return this.can_create = true })
          .catch(() => { return this.can_create = false })
      },
      test_read(id) {
        Vue.set(this, "can_read", {})
        return CourseModel.show(id)
          .then(() => { return Vue.set(this.can_read, id, true) })
          .catch(() => { return Vue.set(this.can_read, id, false) })
      },
      test_update(id) {
        Vue.set(this, "can_update", {})
        return CourseModel.edit(id)
          .then(() => { return Vue.set(this.can_update, id, true) })
          .catch(() => { return Vue.set(this.can_update, id, false) })
      },
      test_delete(id) {
        Vue.set(this, "can_delete", {})
        return CourseModel.test_delete(id)
          .then(() => { return Vue.set(this.can_delete, id, false) })
          .catch(() => { return Vue.set(this.can_delete, id, false) })     
      }
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
                    v-if="viewing_mode === 'index' || viewing_mode === 'published' || viewing_mode === 'review' || viewing_mode === 'drafts'">
                    <button class="button orange-button" 
                      slot="controls"
                      v-if="can_create === true"
                      v-on:click="new_item()">
                      New Course
                    </button>

                    <course-render-small
                      slot="preview"
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

                  </control-list>

                  <control-view 
                    v-if="viewing_mode === 'show'">

                    <course-render-large
                      slot="view"
                      v-bind:schema="schema"
                      v-bind:item="model">
                    </course-render-large>

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
                  </control-view>

                  <control-form 
                    v-if="viewing_mode === 'new' || viewing_mode === 'edit'" 
                    v-bind:schema="schema" 
                    v-bind:item="model" 
                    v-bind:mode="viewing_mode"
                    v-on:changed="changed">

                    <course-render-large
                      slot="preview"
                      v-bind:schema="schema"
                      v-bind:item="model">
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