import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-sidebar-panel',
  templateUrl: './sidebar-panel.component.html',
  styleUrl: './sidebar-panel.component.css'
})
export class SidebarPanelComponent {

  constructor(public authService: AuthService) { }
}
