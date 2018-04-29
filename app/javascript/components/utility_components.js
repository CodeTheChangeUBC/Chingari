import Vue from 'vue/dist/vue.esm'
import { capitalize } from '../layout/utility'

export const StringRender = Vue.component("string-render", {
  props: ["string", "placeholder"],
  template: `
            <span class="string-render">
              <span 
                v-if="string !== undefined && string !== null && string.match(/^\s*$/) === null">
                {{ string }}
              </span>
              <span 
                v-else-if="placeholder !== undefined"
                class="string-render-placeholder" style="opacity: 0.5">
                {{ placeholder }}
              </span>
              <span v-else 
                class="string-render-placeholder" style="opacity: 0.5">
                blank
              </span>
            </span>
            `
})

export const RawRender = Vue.component("raw-render", {
  props: ["string", "placeholder"],
  template: `
            <span class="raw-render">
              <span 
                v-if="string !== undefined && string !== null && string.match(/^\s*$/) === null"
                v-html="string">
              </span>
              <span v-else-if="placeholder !== undefined"
                v-html="placeholder"
                class="raw-render-placeholder" style="opacity: 0.5">
              </span>
              <span v-else 
                class="string-render-placeholder" style="opacity: 0.5">
                blank
              </span>
            </span>
            `
})

// Possible types: text, textarea, number, boolean, enum, date, time, datetime
// Supported so far: text, textarea, number, enum, boolean, link, file, image,

// Alt image render <img v-if="type === 'image'" v-bind:src="value">
export const PropertyOutput = Vue.component("property-output", {
  props: ["label", "value", "type", "name", "imagestyle"],
  methods: {
    capitalize(string) {
      return capitalize(string).replace(/_/g, ' ')
    },
    format_datetime(datetime) {
      const match = datetime.match(/^(\d+-\d+-\d+)T(\d+:\d+)(?::\d+\.\d+Z?)?$/)
      if (match !== null && match.length === 3) {
        return match.slice(1, 3).join(' ')
      } else {
        return datetime
      }
    },
    format_date(date) {
      const match = datetime.match(/^(\d+-\d+-\d+)$/)
      if (match !== null && match.length === 3) {
        return match[1]
      } else {
        return date
      }
    },
    format_time(time) {
      const match = time.match(/^(\d+:\d+)(?::\d+\.\d+Z?)?$/)
      if (match !== null && match.length === 3) {
        return match[1]
      } else {
        return time
      }
    }
  },
  template:`
           <div class="property-output">

            <span v-if="label !== undefined && label.match(/^\s*$/) === null" style="font-weight: bold">
              {{ capitalize(label) }}: 
            </span>

            <span v-if="type === 'text'">
              <string-render
                v-bind:string="value"
                v-bind:placeholder="'Blank'">
              </string-render>
            </span>

            <span v-if="type === 'textarea'">
              <div v-if="value.length > 100">
                <string-render
                  v-bind:string="value"
                  v-bind:placeholder="'Blank'"
                  style="padding-left: 10px">
                </string-render>
              </div>
              <string-render
                v-else
                v-bind:string="value"
                v-bind:placeholder="'Blank'">
              </string-render>
            </span>

            <span v-if="type === 'number'">
              <string-render
                v-bind:string="value"
                v-bind:placeholder="'Blank'">
              </string-render>
            </span>

            <span v-if="type === 'date'">
              <string-render
                v-bind:string="format_date(value)"
                v-bind:placeholder="'Blank'">
              </string-render>
            </span>

            <span v-if="type === 'time'">
              <string-render
                v-bind:string="format_time(value)"
                v-bind:placeholder="'Blank'">
              </string-render>
            </span>

            <span v-if="type === 'datetime'">
              <string-render
                v-bind:string="format_datetime(value)"
                v-bind:placeholder="'Blank'">
              </string-render>
            </span>

            <span v-if="type.constructor === Object">
              <span v-for="(num, name) in type"
                v-if="num === value">
                <string-render
                  v-bind:string="name"
                  v-bind:placeholder="'Blank'">
                </string-render>
              </span>
            </span>

            <span v-if="type === 'boolean'">
              <span v-if="value === true">
                Yes
              </span>
              <span v-if="value === false">
                No
              </span>
            </span>

            <a v-if="type === 'link'" v-bind:href="value">
              <string-render
                v-bind:string="name"
                v-bind:placeholder="value">
              </string-render>
            </a>

            <a v-if="type === 'file'" v-bind:href="value" v-bind:download="value.match(/[a-zA-z-_]+\.?[a-zA-z-_]+$/)[0]">
              <string-render
                v-bind:string="name"
                v-bind:placeholder="value.match(/[a-zA-z-_]+\.?[a-zA-z-_]+$/)[0]">
              </string-render>
            </a>
            
            <div v-if="type === 'image' && style !== undefined && style.match(/^\s*$/) === null"
              v-bind:style="'background-image: url(' + value + ');background-attachment: scroll;background-position: center center;background-repeat: no-repeat;background-size: cover;' + imagestyle">
            </div>

           </div>
           `
})

export const PropertyInput = Vue.component("property-input", {
  props: ["label", "placeholder", "type", "error"],
  data() {
    return {
      value: undefined,
      hint: ""
    }
  },
  methods: {
    changed(new_value, mod) {
      if (mod === "number") {
        new_value = Number(new_value)
      } else if (mod === "trim") {
        new_value = new_value.trim()
      }
      this.value = new_value
      this.$emit("changed", this.label, this.value)
    },
    capitalize(string) {
      return capitalize(string)
    },
    format_datetime(datetime) {
      const match = datetime.match(/^(\d+-\d+-\d+)T(\d+:\d+)(?::\d+\.\d+Z?)?$/)
      if (match !== null && match.length === 3) {
        return match.slice(1, 3).join(' ')
      } else {
        return datetime
      }
    },
    format_date(date) {
      const match = datetime.match(/^(\d+-\d+-\d+)$/)
      if (match !== null && match.length === 2) {
        return match[1]
      } else {
        return date
      }
    },
    format_time(time) {
      const match = time.match(/^(\d+:\d+)(?::\d+\.\d+Z?)?$/)
      if (match !== null && match.length === 2) {
        return match[1]
      } else {
        return time
      }
    },
    parse_datetime(datetime) {
      const match = datetime.trim().match(/^(\d+-\d+-\d+)\s(\d+:\d+)$/)
      if (match !== null && match.length === 3) {
        this.hint = ""
        return match[1] + "T" + match[2] + "00.000Z"
      } else {
        const hint = "Oops! Something's wrong, please follow the format 'yyyy-MM-dd hh:mm'."
        this.hint = hint
        return hint
      }
    },
    parse_date(date) {
      const match = datetime.trim().match(/^(\d+-\d+-\d+)$/)
      if (match !== null && match.length === 2) {
        this.hint = ""
        return match[1]
      } else {
        const hint = "Oops! Something's wrong, please follow the format 'yyyy-MM-dd'."
        this.hint = hint
        return hint
      }
    },
    parse_time(time) {
      const match = datetime.trim().match(/^(\d+:\d+)$/)
      if (match !== null && match.length === 2) {
        this.hint = ""
        return match[1]
      } else {
        const hint = "Oops! Something's wrong, please follow the format 'hh:mm'."
        this.hint = hint
        return hint
      }
    }
  },
  created() {
    this.value = this.placeholder
  },
  template: `
            <div class="form-group property-input">
              <label 
                v-bind:for="label">
                {{ capitalize(label) }}
              </label>

              <input 
                v-if="type === 'text'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event.target.value, 'trim')" 
                type="text" 
                class="form-control">

              <input 
                v-if="type === 'password'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event.target.value, 'trim')" 
                type="password" 
                class="form-control">

              <textarea 
                v-if="type === 'textarea'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event.target.value, 'trim')" 
                type="textarea" 
                class="form-control">
              </textarea>

              <input 
                v-if="type === 'number'" 
                v-bind:placeholder="label"
                v-bind:value="value"
                v-on:input="changed($event.target.value, 'number')" 
                type="number" 
                class="form-control">

              <input 
                v-if="type === 'date'" 
                v-bind:placeholder="'yyyy-mm-dd'"
                v-bind:value="value"
                v-on:input="changed(parse_date($event.target.value))" 
                type="date" 
                class="form-control">

              <input 
                v-if="type === 'time'" 
                v-bind:placeholder="'hh:mm'"
                v-bind:value="value"
                v-on:input="changed(parse_time($event.target.value))" 
                type="date" 
                class="form-control">

              <input 
                v-if="type === 'datetime'" 
                v-bind:placeholder="'yyyy-MM-dd hh:mm'"
                v-bind:value="value"
                v-on:input="changed(parse_datetime($event.target.value))" 
                type="datetime-local" 
                class="form-control">

              <input 
                v-if="type === 'boolean' && value === true" 
                v-bind:placeholder="label"
                v-on:click="changed($event.target.checked)" 
                type="checkBox" 
                class="form-control" checked>
              <input 
                v-if="type === 'boolean' && value === false" 
                v-bind:placeholder="label"
                v-on:click="changed($event.target.checked)" 
                type="checkBox" 
                class="form-control">

              <select 
                v-if="type.constructor === Object" 
                v-on:change="changed($event.target.value, 'number')" 
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

              <small class="form-text">
                <string-render
                  v-bind:string="hint"
                  v-bind:placeholder="''">
                </string-render>
              </small>

              <small
                v-if="error !== undefined"
                class="form-text">
                <div v-for="reason in error">
                  <string-render
                    v-bind:string="capitalize(label) + ' ' + reason"
                    v-bind:placeholder="''">
                  </string-render>
                </div>
              </small>

            </div>
            `
})