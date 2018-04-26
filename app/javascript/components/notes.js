import Vue from 'vue/dist/vue.esm'

export const Note = Vue.component("note", {
  props: ["id", "message", "theme"],
  template: `<div class="text note" v-bind:class="theme">
                {{ message }}
                <span class="subtext dismiss" v-on:click="$emit('dismiss', id)">
                  <i class="fa fa-times"></i>
                </span>
              </div>`
})
