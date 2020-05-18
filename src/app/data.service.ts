import {Injectable} from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {DatePipe} from "@angular/common";
import {Observable} from "rxjs";
import {Sample} from "./models/data.interface";
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class DataService {

  constructor(private http: HttpClient, public datepipe: DatePipe) {
  }

  getHash(sampleId: string, name: string, birthday: string): Observable<string> {
    birthday = this.datepipe.transform(birthday, 'yyyy-MM-dd');

    return this.http.get<string>(
      environment.baseurl + `/hashes?sampleId=${sampleId}&name=${name}&birthday=${birthday}`
    );
  }

  getData(hash:string) {
    return this.http.get<Sample>(
      environment.baseurl + `/tests/${hash}`
    );
  }
}
