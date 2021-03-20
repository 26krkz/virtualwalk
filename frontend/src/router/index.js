import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import SignUp from '../views/SignUp.vue'
import LogIn from '../views/LogIn.vue'
import LogOut from '../views/LogOut.vue'
import GuestUser from '../views/GuestUser.vue'
import User from '../views/User.vue'

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
    path: '/login',
    name: 'LogIn',
    component: LogIn
  },
  {
    path: '/logout',
    name: 'Logout',
    component: LogOut
  },
  {
    path: '/guest',
    name: 'GuestUser',
    component: GuestUser
  },
  {
    path: '/:username',
    name: 'User',
    component: User,
  },

]

const router = new VueRouter({
  routes
})

export default router
