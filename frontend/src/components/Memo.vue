<template>
  <v-data-table
    :headers="headers"
    :items="memos"
    hide-default-footer
    class="elevation-1"
  >
    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>メモ</v-toolbar-title>
        <!-- <v-divider class="mx-4" inset vertical></v-divider> -->
        <v-spacer></v-spacer>

        <!-- メモの追加、編集ダイアログ -->
        <v-dialog v-model="dialog" max-width="500px">
          <!-- クリックイベントでダイアログを使うためにはv-dialog内でスロットのアクティベイターを指定する必要がある。スロットはtemplateでしか定義できないから
          templateでスロットを指定して、その中でボタンの定期をする。 -->
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="cyan" dark class="mb-2" v-bind="attrs" v-on="on">メモの追加</v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="text-h5">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="5" sm="4">
                    <vue-timepicker
                      format="H:mm:ss"
                      placeholder="時間を入力"
                      :hour-range="[[0, 3]]"
                      hide-disabled-hours
                      v-model="editedItem.time"
                    >
                    </vue-timepicker>
                  </v-col>
                  <v-col cols="12">
                    <v-text-field v-model="editedItem.comment" label="コメント"></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="cyan" dark @click="close">キャンセル</v-btn>
              <v-btn color="cyan" dark @click="save">保存</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <!-- メモの削除ダイアログ -->
        <v-dialog v-model="dialogDelete" max-width="430px">
          <v-card>
            <v-card-title>このメモを削除しますか？</v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="cyan" dark @click="closeDelete">キャンセル</v-btn>
              <v-btn color="pink" dark @click="deleteItemConfirm">削除</v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>

    <template v-slot:[`item.actions`]="{ item }">
      <!-- editItem()を発火させ編集ダイアログを表示する。 -->
      <v-icon color="warning" class="mr-3" @click="editItem(item)">mdi-pencil</v-icon>
      <!-- deleteItem()を発火させ削除ダイアログを表示する。 -->
      <v-icon color="pink" @click="deleteItem(item)">mdi-delete</v-icon>
    </template>
  </v-data-table>
</template>
<script>
import VueTimepicker from 'vue2-timepicker/src/vue-timepicker.vue'
  export default {
    data() {
      return {
        dialog: false,
        dialogDelete: false,
        headers: [
          { text: '時間',
            value: 'time', 
            width: '10%', 
            align: 'start',
            sortable: false 
          },
          {
            text: 'コメント',
            value: 'comment',
            sortable: false,
          },
          { text: '編集／削除', 
            value: 'actions',
            align: 'end',
            sortable: false,
          },
        ],
        memos: [],
        editedIndex: -1,
        editedItem: {
          time: "0",
          comment: "",
        },
        defaultItem: {
          time: "0",
          comment: "",
        },
      }
    },
    watch: {
      dialog (val) {
        val || this.close()
      },
      dialogDelete (val) {
        val || this.closeDelete()
      },
    },
    created () {
      // axios.getの処理
      this.memos = [
          {
            time: "0:13:15",
            comment: '緑が綺麗。',
          },
          {
            time: "1:20:00",
            comment: '旧市街の街並み',
          },
        ]
    },
    methods: {
      editItem (item) {
        // indexOf()によってmemos配列内にitemと一致する要素があるか調べる。あったらその要素のindex(> -1)を返す。
        this.editedIndex = this.memos.indexOf(item);
        this.editedItem = Object.assign({}, item);
        this.dialog = true;
      },

      deleteItem (item) {
        this.editedIndex = this.memos.indexOf(item);
        this.editedItem = Object.assign({}, item);
        this.dialogDelete = true;
      },

      deleteItemConfirm () {
        this.memos.splice(this.editedIndex, 1);
        this.closeDelete();
      },

      close () {
        this.dialog = false;
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem);
          this.editedIndex = -1;
        })
      },

      closeDelete () {
        this.dialogDelete = false;
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem);
          this.editedIndex = -1;
          // axios.deleteの処理
        })
      },

      save () {
        if (this.editedIndex > -1) {
          Object.assign(this.memos[this.editedIndex], this.editedItem);
          // axios.patchの処理
        } else {
          this.memos.push(this.editedItem);
          // axios.postの処理
        }
        this.close();
      }
    },
    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'メモの追加' : 'メモの編集'
      }
    },
    components: {
      'vue-timepicker': VueTimepicker,
    }
  }
</script>