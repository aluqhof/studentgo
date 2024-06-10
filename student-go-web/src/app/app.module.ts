import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomePageComponent } from './ui/home-page/home-page.component';
import { NavBarComponent } from './components/nav-bar/nav-bar.component';
import { authInterceptorProviders } from './helpers/auth.interceptor';
import { HttpClientModule, provideHttpClient, withFetch } from '@angular/common/http';
import { DatePipe } from '@angular/common';
import { AdminDashboardComponent } from './ui/admin-dashboard/admin-dashboard.component';
import { SidebarPanelComponent } from './components/sidebar-panel/sidebar-panel.component';
import { AdminEventsComponent } from './ui/admin-events/admin-events.component';
import { ModalCitiesComponent } from './components/modal-cities/modal-cities.component';
import { ModalLoginComponent } from './components/modal-login/modal-login.component';
import { FormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AdminPurchasesComponent } from './ui/admin-purchases/admin-purchases.component';

@NgModule({
  declarations: [
    AppComponent,
    HomePageComponent,
    NavBarComponent,
    AdminDashboardComponent,
    SidebarPanelComponent,
    AdminEventsComponent,
    ModalCitiesComponent,
    ModalLoginComponent,
    AdminPurchasesComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    BrowserAnimationsModule,
    HttpClientModule
  ],
  providers: [
    authInterceptorProviders, provideHttpClient(withFetch()), DatePipe
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
}
