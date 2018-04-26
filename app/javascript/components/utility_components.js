import Vue from 'vue/dist/vue.esm'

export const StringRender = Vue.component("string-render", {
  props: ["string", "placeholder"],
  template: `
            <span class="string-render">
              <span v-if="string.match(/^\s*$/) === null">
                {{ string }}
              </span>
              <span v-else-if="placeholder !== undefined" class="string-render-placeholder" style="opacity: 0.5">
                {{ placeholder }}
              </span>
              <span v-else class="string-render-placeholder" style="opacity: 0.5">
                blank
              </span>
            </span>
            `
})

export const PropertyInput = Vue.component("property-input", {
  props: ["label", "placeholder", "type"],
  data() {
    return {
      value: undefined
    }
  },
  methods: {
    changed(event, mod) {
      let new_value = event.target.value
      if (mod === "number") {
        new_value = Number(new_value)
      } else if (mod === "trim") {
        new_value = new_value.trim()
      }
      this.value = new_value
      this.$emit("changed", this.label, this.value)
    }
  },
  created() {
    this.value = this.placeholder
  },
  template: `
            <div class="form-group property-input">
              <label 
                v-bind:for="label">
                {{ label }}
              </label>
              <input 
                v-if="type === 'text'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event, 'trim')" 
                type="text" 
                class="form-control">
              <textarea 
                v-if="type === 'textarea'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event, 'trim')" 
                type="textarea" 
                class="form-control">
              </textarea>
              <input 
                v-if="type === 'number'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event, 'number')" 
                type="number" 
                class="form-control">
              <select 
                v-if="type.constructor === Object" 
                v-on:change="changed($event, 'number')" 
                type="enumerable" 
                class="form-control">
                <option 
                  v-for="(num, name) in type" 
                  v-if="num === placeholder" 
                  v-bind:value="num" 
                  selected>
                  {{ name }}
                </option>
                <option 
                  v-for="(num, name) in type" 
                  v-if="num !== placeholder" 
                  v-bind:value="num">
                  {{ name }}
                </option>
              </select>
            </div>
            `
})