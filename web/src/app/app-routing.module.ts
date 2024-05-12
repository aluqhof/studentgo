import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomePageComponent } from './ui/home-page/home-page.component';
import { LoginPageComponent } from './ui/login-page/login-page.component';

export const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  //{ path: 'register', component: RegisterUserFormComponent },
  { path: 'login', component: LoginPageComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
