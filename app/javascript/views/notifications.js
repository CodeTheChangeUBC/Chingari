import Vue from 'vue/dist/vue.esm'
import Note from '../components/notes'

export function Notifications(mount) {
  return new Vue({
    el: mount,
    data() {
      return {
        id: 0,
        notes: [],
        lifespan: 10000
      }
    },
    methods: {
      dismiss(id) {
        let index = this.notes.findIndex((note) => note.id === id)
        if (index !== -1) {
          this.notes.splice(index, 1)
        }
      },
      notify(message) {
        let id = this.id++
        this.notes.push({ theme: "dark-theme blue-text", message: message, id: id })
        setTimeout(() => {
          this.dismiss(id)
        }, this.lifespan)
      },
      error(message) {
        let id = this.id++
        this.notes.push({ theme: "dark-theme orange-text", message: message, id: id })
        setTimeout(() => {
          this.dismiss(id)
        }, this.lifespan)
      },
      clear() {
        Vue.set(this, "notes", [])
      }
    },
    template: `
              <div class="note-pad">
                <transition-group name="slide-fade" v-on:dismiss="$emit('dismiss', $event)">
                  <note
                    v-for="(note, index) in this.notes"
                    v-bind:key="note.id"
                    v-bind:id="note.id"
                    v-bind:message="note.message"
                    v-bind:theme="note.theme"
                    v-on:dismiss="dismiss(note.id)"
                  ></note>
                </transition-group>
              </div>
              `
  })
}