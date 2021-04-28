<template>
    <v-main>
        <v-container class="main-container">
            <v-row>
                <v-col cols="12" md="6">
                    <div class="img-wrapper">
                        <img class="page-image" src="../assets/top_page.jpeg" >
                    </div>
                    <ol>
                        <li>ゲストユーザーでログインしても利用できます。</li>
                        <li>マップのマーカーをクリックして動画を選択できます。</li>
                        <li>ユーザーにお気に入りに追加された動画のベスト５が表示されます。</li>
                        <li>動画には撮影された地域、国、場所、時間のタグ付けがされています。
                            <br>ログインすると選択した動画をお気に入りに追加できます。
                            <br>開始時間、再生時間の指定もできます。</li>
                        <li>地域別に分けられたタブからも動画を選択できます。</li>
                    </ol>
                </v-col>
                <v-col cols="12" md="6">
                    <div class="img-wrapper">
                        <img class="page-image" src="../assets/user_page.jpeg" > 
                    </div>
                    <ol start="6">
                        <li>ユーザー情報を変更できます。名前とメールアドレスは必須です。</li>
                        <li>お気に入りに追加された動画が一覧で表示されます。</li>
                        <li>ユーザーページでもお気に入りの動画を視聴できます。</li>
                    </ol>
                </v-col>
            </v-row>
            <v-row>
                <v-col cols="12" md="8">
                    <div class="comment-wrapper">
                        <v-card class="grey lighten-3">
                            <div class="comment">
                                virtualwalkは普段私が観るYoutubeの世界の風景動画を視聴しやすくすることを目的として作成しました。
                                <br>このアプリは扱いやすさを重視したシンプルな機能で構成されています。
                                <br>マップ、ランキング、地域別検索タブから動画を選択し視聴してください。選択した動画はそのままでも視聴できますが、
                                    特定の時間指定も可能です。
                                <br>今回は「風景＋環境音のみ」のシンプルな動画を集め、私は作業用BGMとして使っています。
                                <br>そこで動画自体をタイマーとしても使いたいと考え、再生時間を指定できるようにしました。
                                    また開始時間の指定も行えるようにしています。
                                <br>ユーザー登録を行えば、動画をお気に入りに追加することもできます。
                                <br>ランキングではお気に入りに追加された動画のうち回数の多いベスト５が表示されるようになっています。
                                <br>こんなご時世で海外にも行けなくなっていますが、ネットには世界の景色で溢れています。
                                <br>是非ゲストユーザーで遊んでみてください。
                            </div>
                        </v-card>
                    </div>
                </v-col>
            </v-row>
        </v-container>
    </v-main>
</template>

<style scoped>
.main-container {
    margin-top: 30px;
    margin-bottom: 30px;
}
.img-wrapper {
  width:100%;
  padding-top:110%;
  position: relative;
  margin:auto;
  }
.page-image {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  }
.comment-wrapper {
    margin-top: 30px;
}
.comment {
    padding: 20px;
}
</style>