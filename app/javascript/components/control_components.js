import Vue from 'vue/dist/vue.esm'
import { StringRender, PropertyInput, PropertyOutput } from '../components/utility_components'

// Model Form, applies property-input for complex item and schema and emits the input as an item state
export const ModelForm = Vue.component("model-form", {
  props: ["item", "schema", "errors"],
  data() {
    return {
      model: {}
    }
  },
  methods: {
    changed(key, value) {
      Vue.set(this.model, key, value)
      this.$emit("changed", this.model)
    }
  },
  created() {
    Vue.set(this, "model", JSON.parse(JSON.stringify(this.item)))
  },
  template: `
            <form class="model-form">
              <property-input v-for="(type, label) in schema" 
                v-bind:key="label"
                v-bind:label="label" 
                v-bind:placeholder="item[label]" 
                v-bind:type="type"
                v-bind:error="errors[label]"
                v-on:changed="changed">
              </property-input>
            </form>
            `
})

// Model View, applies property-output for complex item and schema and emits the input as an item state
export const ModelView = Vue.component("model-view", {
  props: ["item", "schema"],
  template: `
            <div class="model-view">
              <slot name="header"></slot>
              <property-output v-for="(type, label) in schema" 
                v-bind:key="label"
                v-bind:label="label" 
                v-bind:value="item[label]"
                v-bind:type="type">
              </property-output>
              <slot name="footer"></slot>
            </div>
            `
})

// A template containing a model-form plus placement slots for control buttons and a preview
export const ControlForm = Vue.component("control-form", {
  props: ["schema", "item", "mode", "errors"],
  data() {
    return {
      model: {}
    }
  },
  methods: {
    changed(new_model) {
      Vue.set(this, "model", new_model)
      this.$emit("changed", this.model)
    }
  },
  created() {
    Vue.set(this, "model", JSON.parse(JSON.stringify(this.item)))
  },
  template: `
            <div class="control-form row">

              <div class="col-lg-6 col-sm-12">
  
                <div class="form shadow-box" style="margin: 5px 0px 5px 0px">
                  <model-form
                    v-bind:item="item"
                    v-bind:schema="schema"
                    v-bind:errors="errors"
                    v-on:changed="changed">
                  </model-form>

                  <slot name="controls"></slot>
                </div>

              </div>

              <div class="col-lg-6 col-sm-12">

                <div class="preview material-shadow" 
                  style="margin:5px 0px 5px 0px">
                  <slot name="preview"></slot>
                </div>

              </div>
            </div>
            `
})

// A template with placement slots for control buttons and a preview for listing items
export const ControlList = Vue.component("control-list", {
  template: `
            <div class="control-list">
              <div class="row" style="padding: 15px">
                <div class="col-sm-12">
                  <slot name="controls"></slot>
                </div>
              </div> 
              <div class="row">
                <slot name="preview"></slot>
              </div>
            </div>
            `
})

// A template with placement  slots for control buttons and a large view
export const ControlView = Vue.component("control-view", {
  template: `
            <div class="control-view">
              <div class="row" style="padding: 15px">
                <div class="col-sm-12">
                  <slot name="view"></slot>
                </div>
              </div> 
            </div>
            `
})