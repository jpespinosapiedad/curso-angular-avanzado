import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CounterComponent } from '@shared/components/counter/counter.component';
import { HighlightDirective } from '@shared/directives/highlight.directive';

import { WaveAudioComponent } from '@info/components/wave-audio/wave-audio.component';
import { FormsModule } from '@angular/forms';
import { BehaviorSubject, delay, Subject } from 'rxjs';
import { toSignal } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-about',
  imports: [
    CommonModule,
    FormsModule,
    CounterComponent,
    WaveAudioComponent,
    HighlightDirective,
  ],
  templateUrl: './about.component.html',
})
export default class AboutComponent {
  duration = signal(1000);
  message = signal('Hola');

  obsWithInit$ = new BehaviorSubject<string>('obsWithInit$ initial value');
  $withInit = toSignal(this.obsWithInit$, {
    requireSync: true,
  });

  obsWithoutInit$ = new Subject<string>();
  $withoutInit = toSignal(this.obsWithoutInit$.pipe(delay(3000)), {
    initialValue: 'obsWithoutInit$ initial value',
  });

  changeDuration(event: Event) {
    const input = event.target as HTMLInputElement;
    this.duration.set(input.valueAsNumber);
  }

  changeMessage(event: string) {
    console.log('change message', event);
  }

  emitWithInit() {
    this.obsWithInit$.next('obsWithInit$ new value');
  }

  emitWithoutInit() {
    this.obsWithoutInit$.next('obsWithoutInit$ new value');
  }
}
