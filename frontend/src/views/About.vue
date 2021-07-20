<template>
    <v-main>
        <v-container class="main-container">
            <v-row>
                <v-col cols="12" md="6">
                    <div class="home-img-wrapper">
                        <img class="page-image" src="../assets/home-image.png" >
                    </div>
                    <ol>
                        <li>ゲストユーザーでログインしても利用できます。</li>
                        <li>タグを使って動画を検索できます。（ヨーロッパ、フランス、首都、世界遺産など）</li>
                        <li>マップのマーカーをクリックして動画を選択できます。</li>
                        <li>ボタンを押すと動画をランダムに選んでくれます。</li>
                        <li>ユーザーにお気に入りに追加された動画のベスト５が表示されます。</li>
                        <li>動画には撮影された地域、国、場所、時間のタグ付けがされています。
                            <br>ログインすると選択した動画をお気に入りに追加できます。
                            <br>開始時間、再生時間の指定もできます。</li>
                        <li>地域別に分けられたタブからも動画を選択できます。</li>
                    </ol>
                </v-col>
                <v-col cols="12" md="6">
                    <div class="user-img-wrapper">
                        <img class="page-image" src="../assets/user-image.png" > 
                    </div>
                    <ol start="8">
                        <li>ユーザー情報を変更できます。名前とメールアドレスは必須です。</li>
                        <li>お気に入りに追加された動画が一覧で表示されます。</li>
                        <li>お気に入りに追加した動画の中でもお気に入りのシーンを時間とコメントを付けて
                            <br>メモすることができます。
                            <br>メモした時間は開始時間としても指定することができるようになります。</li>
                        <li>ユーザーページでもお気に入りの動画を視聴できます。</li>
                    </ol>
                </v-col>
            </v-row>
            <v-row>
                <v-col cols="12" md="9">
                    <div class="comment-wrapper">
                        <v-card class="grey lighten-3">
                            <div class="comment">
                                <h2>【virtualwalkとは】</h2>
                                <p>「virtualwalk」は私がyoutube上で「virtual walking tour」と検索している<span class="comment-bold">海外の風景動画</span>を視聴しやすくすることを目的として作成しました。</p>
                                <p>上記の海外風景の動画はほとんどは外国の方が撮影した動画であるため<span class="comment-bold">日本語</span>で検索することができません。
                                <br>かと言ってそれ以上検索で絞り込みを行おうとすると都市名（Paris）などの英字名で検索する必要があり、
                                    そのスペルを知るためにはカタカナで「パリ」とググる必要があります。<span class="comment-bold">面倒ですね。</span>
                                    そこで動画にタグを付けることでカタカナで「ヨーロッパ」「フランス」や「首都」「世界遺産」など日本語のキーワードで検索できるようにしました。</p>
                                <p>そしてどこで撮影されたのかわかるように、動画を選択した時にGoogleマップ上で<span class="comment-bold">撮影場所にズーム</span>するようになっています。
                                    選択するのも面倒な時はランダム選択機能を使ってみてください。</p>
                                <p>ユーザー登録（またはゲストユーザー登録）を行えば、動画を<span class="comment-bold">お気に入りに追加</span>することもできます。
                                    お気に入りに追加した動画は<span class="comment-bold">メモ機能</span>を使って時間をメモすることでいつでもお気に入りのシーンから再生することができます。</p>
                                <p>旅行に行く前の下調べに使うのも良いかもしれません。
                                <br>ぜひゲストユーザーで遊んでみてください。</p>
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
.home-img-wrapper {
  width:100%;
  padding-top:110%;
  position: relative;
  margin:auto;
  }
.user-img-wrapper {
  width:100%;
  padding-top:132%;
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
    font-size: 16.5px
}
.comment-bold {
    font-size: 19px;
    font-weight: bold;
}
</style>