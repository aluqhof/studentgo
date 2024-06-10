import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomePageComponent } from './ui/home-page/home-page.component';
import { AdminDashboardComponent } from './ui/admin-dashboard/admin-dashboard.component';
import { AdminGuard } from './auth.guard';
import { AdminEventsComponent } from './ui/admin-events/admin-events.component';
import { AdminPurchasesComponent } from './ui/admin-purchases/admin-purchases.component';

const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  {
    path: 'admin',
    children: [
      { path: '', component: AdminDashboardComponent, canActivate: [AdminGuard] },
      { path: 'events', component: AdminEventsComponent, canActivate: [AdminGuard] },
      { path: 'purchases', component: AdminPurchasesComponent, canActivate: [AdminGuard] },
      //{ path: 'issues', component: AdminIssuesPageComponent, canActivate: [AuthGuard] },
      //{ path: 'travels', component: PageAdminTravelsComponent, canActivate: [AuthGuard] }
    ]
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

/**
 * export const routes: Routes = [
  { path: 'home', component: HomePageComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'register', component: RegisterPageComponent },
  { path: 'login', component: LoginPageComponent },
  {
    path: 'admin',
    children: [
      //{ path: 'bikes', component: AdminBikesPageComponent, canActivate: [AuthGuard] },
      //{ path: 'stations', component: AdminStationsPageComponent, canActivate: [AuthGuard] },
      //{ path: 'issues', component: AdminIssuesPageComponent, canActivate: [AuthGuard] },
      //{ path: 'travels', component: PageAdminTravelsComponent, canActivate: [AuthGuard] }
    ]
  },
  {
    path: 'organizer',
    children: [
      { path: 'dashboard', component: OrganizerDashboardComponent, canActivate: [OrganizerGuard] },
      { path: 'events', component: OrganizerEventsComponent, canActivate: [OrganizerGuard] }
    ]
  },
];
 */
