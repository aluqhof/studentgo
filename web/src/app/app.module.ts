import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NgbCollapse, NgbDropdownModule, NgbModalModule, NgbModule, NgbPagination } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, provideHttpClient, withFetch } from '@angular/common/http';
import { CommonModule, DatePipe } from '@angular/common';
import { HomePageComponent } from './ui/home-page/home-page.component';
import { LoginPageComponent } from './ui/login-page/login-page.component';
import { NavBarComponent } from "./comps/nav-bar/nav-bar.component";
import { RegisterPageComponent } from './ui/register-page/register-page.component';
import { OrganizerDashboardComponent } from './ui/organizer-dashboard/organizer-dashboard.component';
import { authInterceptorProviders } from './helpers/auth.interceptor';
import { OrganizerNavBarComponent } from './comps/organizer-nav-bar/organizer-nav-bar.component';
import { OrganizerEventsComponent } from './ui/organizer-events/organizer-events.component';
//import { MatGoogleMapsAutocompleteModule } from '@angular-material-extensions/google-maps-autocomplete';

@NgModule({
  declarations: [
    AppComponent,
    HomePageComponent,
    LoginPageComponent,
    RegisterPageComponent,
    NavBarComponent,
    OrganizerDashboardComponent,
    OrganizerNavBarComponent,
    OrganizerEventsComponent],
  bootstrap: [AppComponent],
  imports: [
    BrowserModule,
    AppRoutingModule,
    NgbModule,
    FormsModule,
    HttpClientModule,
    CommonModule,
    ReactiveFormsModule,
    NgbDropdownModule,
    NgbModalModule,
    NgbCollapse,
    NgbPagination,
    //MatGoogleMapsAutocompleteModule.forRoot('AIzaSyAlKtaZlLjfVcE6fktFj9SB1wqRpFjQtFE')
  ],
  providers: [authInterceptorProviders, provideHttpClient(withFetch()), DatePipe],
})
export class AppModule { }
