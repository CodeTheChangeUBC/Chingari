import Vue from 'vue/dist/vue.esm'
import { StringRender, PropertyInput } from '../components/utility_components'

// Model Form, applies property-input for complex item and schema and emits the input as an item state
export const ModelForm = Vue.component("model-form", {
  props: ["item", "schema"],
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
                v-on:changed="changed">
              </property-input>
            </form>
            `
})

// A template containing a model-form plus placement slots for control buttons and a preview
export const ControlForm = Vue.component("control-form", {
  props: ["schema", "item", "mode"],
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
              <div class="preview col-lg-6 col-sm-12">
                <slot name="preview"></slot>
              </div>

              <div class="form col-lg-6 col-sm-12">
              
                <model-form
                  v-bind:item="item"
                  v-bind:schema="schema"
                  v-on:changed="changed">
                </model-form>

                <slot name="controls"></slot>

              </div>
            </div>
            `
})

// A template with placement slots for control buttons and a preview for listing items
export const ControlList = Vue.component("control-list", {
  template: `
            <div class="control-list">
              <slot name="controls"></slot>
              <br> 
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
              <slot name="view"></slot>
              <slot name="controls"></slot>
            </div>
            `
})