import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import SignUp from '../views/SignUp.vue'
import SignIn from '../views/SignIn.vue'
import LogOut from '../views/LogOut.vue'
// import Users from '../views/Users.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/signup',
    name: 'SignUp',
    component: SignUp
  },
  {
    path: '/signin',
    name: 'SignIn',
    component: SignIn
  },
  {
    path: '/logout',
    // redirect: { name: 'Home' },
    name: 'Logout',
    component: LogOut
  },
  // {
  //   path: '/users/:id',
  //   name: 'Users',
  //   component: Users
  // }

]

const router = new VueRouter({
  routes
})

export default router
