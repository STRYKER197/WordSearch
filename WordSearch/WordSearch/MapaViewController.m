//
//  MapaViewController.m
//  WordSearch
//
//  Created by Rodrigo Silva on 5/8/15.
//  Copyright (c) 2015 Rodrigo Silva. All rights reserved.
//

#import "MapaViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SCLAlertView.h"
#import "CustomAnnotation.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Score.h"
#import "GameKitHelper.h"
@import CoreData;


#define qtd 142

@interface MapaViewController (){
    AVAudioPlayer *_audioPlayer;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

int counter = 0;
NSArray *languageArray;
NSArray *paisesArray;
NSString *paisSearch;
CLGeocoder *ceo;
CLLocation *loc;
NSMutableArray *numerosSorteados;
NSTimer *myTimer;
NSTimer *timer;
double timerInterval = 20.0;
double timerElapsed = 0.0;
NSDate *timerStarted;

@implementation MapaViewController
@synthesize lblPoint, lblTime, lblPais, mapKit;


-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Altera a variavel de controle
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:@"1" forKey:@"inMap"];

    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //Define o idioma dos paises do jogo.
    if ([language isEqualToString:@"pt"]) {
        paisesArray = @[@"Canadá", @"Estados Unidos da América", @"México", @"Guatemala", @"Honduras", @"Nicarágua", @"Costa Rica", @"Panamá", @"Cuba", @"Jamaica", @"Bahamas", @"República Dominicana", @"Haiti", @"Belize", @"Brasil", @"Guiana Francesa", @"Guiana", @"Venezuela", @"Colômbia", @"Equador", @"Peru", @"Bolívia", @"Chile", @"Paraguai", @"Argentina", @"Uruguai", @"Suriname", @"Groenlândia", @"Islândia", @"Noruega", @"Suécia", @"Finlândia", @"Dinamarca", @"Estônia", @"Letônia", @"Lituânia", @"Bielorrússia", @"Ucrânia", @"Moldávia", @"Romênia", @"Bulgária", @"Albânia", @"Grécia", @"Sérvia", @"Bósnia-Herzegovina", @"Croácia", @"Hungria", @"República da Eslovênia", @"Áustria", @"Eslováquia", @"República Checa", @"Polônia", @"Alemanha", @"Suíça", @"Itália", @"Países Baixos", @"Bélgica", @"França", @"Espanha", @"Portugal", @"Reino Unido", @"Irlanda", @"África do Sul", @"Madagascar", @"Moçambique", @"Zimbábue", @"Botsuana", @"Namíbia", @"Maláui", @"Zâmbia", @"Angola", @"Tanzânia", @"Congo", @"Gabão", @"Quênia", @"Uganda", @"Somália", @"Etiópia", @"Sudão do Sul", @"República Centro-Africana", @"Camarões", @"Nigéria", @"Burkina Faso", @"Togo", @"Benin", @"Gana", @"Costa do Marfim", @"Libéria", @"Serra Leoa", @"Guiné", @"Senegal", @"Mauritânia",@"Marrocos", @"Mali", @"Argélia", @"Tunísia", @"Níger", @"Líbia", @"Chade", @"Egito", @"Sudão", @"Austrália", @"Nova Zelândia", @"Papua Nova-Guiné", @"Rússia", @"Jordânia", @"Arábia Saudita", @"Iêmen", @"E.A.U.", @"Omã", @"Iraque", @"Irã", @"Turquia", @"Azerbaijão", @"Geórgia", @"Síria", @"Irã", @"Afeganistão", @"Paquistão", @"Tadjiquistão", @"Uzbequistão", @"Turcomenistão", @"Quirguistão", @"Cazaquistão", @"Índia", @"Nepal", @"Butão", @"Sri Lanka", @"Bangladesh", @"China", @"Myanmar (Birmânia)", @"Laos", @"Tailândia", @"Vietnã", @"Malásia", @"Indonésia", @"Filipinas", @"Taiwan", @"Mongólia", @"Coreia do Norte", @"Coreia do Sul", @"Japão"];
        
        languageArray = @[
                @"Instruções", @"Pressione e Segure na área do País solicitado para pontuar.", @"Começar o jogo",
                @"Fim de Jogo", @"Pontuação: %@", @"Ok",
                @"Pause", @"Não vale procurar no atlas ok?", @"Cancelar", @"Sair do Jogo", @"Reiniciar"
                        ];
    } else {
        paisesArray = @[@"Canada", @"United States", @"Mexico", @"Guatemala", @"Honduras", @"Nicaragua", @"Costa Rica", @"Panama", @"Cuba", @"Jamaica", @"Bahamas", @"Dominican Republic", @"Haiti", @"Belize", @"Brazil", @"French Guiana", @"Guyana", @"Venezuela", @"Colombia", @"Ecuador", @"Peru", @"Bolivia", @"Chile", @"Paraguay", @"Argentina", @"Uruguay", @"Suriname", @"Greenland", @"Iceland", @"Norway", @"Sweden", @"Finland", @"Denmark", @"Estonia", @"Latvia", @"Lithuania", @"Belarus", @"Ukraine", @"Moldova", @"Romania", @"Bulgaria", @"Albania", @"Greece", @"Serbia", @"Bosnia and Herzegovina", @"Croatia", @"Hungary", @"Slovenia", @"Austria", @"Slovakia", @"Czech Republic", @"Poland", @"Germany", @"Switzerland", @"Italy", @"The Netherlands", @"Belgium", @"France", @"Spain", @"Portugal", @"United Kingdom", @"Ireland", @"South Africa", @"Madagascar", @"Mozambique", @"Zimbabwe", @"Botswana", @"Namibia", @"Malawi", @"Zambia", @"Angola", @"Tanzania", @"Congo", @"Gabon", @"Kenya", @"Uganda", @"Somalia", @"Ethiopia", @"South Sudan", @"Central African Republic", @"Cameroon", @"Nigeria", @"Burkina Faso", @"Togo", @"Benin", @"Ghana", @"Ivory Coast", @"Liberia", @"Sierra Leone", @"Guinea", @"Senegal", @"Mauritania", @"Morocco", @"Mali", @"Algeria", @"Tunisia", @"Niger", @"Libya", @"Chad", @"Egypt", @"Sudan", @"Australia", @"New Zealand", @"Papua New Guine", @"Russia", @"Jordan", @"Saudi Arabia", @"Yemen", @"United Arab Emirates", @"Oman", @"Iraq", @"Iran", @"Turkey", @"Azerbaijan", @"Georgia", @"Syria", @"Iran", @"Afghanistan", @"Pakistan", @"Tajikistan", @"Uzbekistan", @"Turkmenistan", @"Kyrgyzstan", @"Kazakhstan", @"India", @"Nepal", @"Bhutan", @"Sri Lanka", @"Bangladesh", @"China", @"Myanmar", @"Laos", @"Thailand", @"Vietnam", @"Malaysia", @"Indonesia", @"Philippines", @"Taiwan", @"Mongolia", @"North Korea", @"South Korea", @"Japan"];
        
        languageArray = @[
                          @"Instructions", @"Tap and Hold the requested Country area to score.", @"Start the game",
                          @"Game Over", @"Score: %@",@"Ok",
                          @"Pause", @"Don't search at the atlas ok?", @"Cancel", @"Quit Game", @"Reset Game"];
    }
    
    UILongPressGestureRecognizer *toqueLongo = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(adicionarPino:)];
    //Tempo a ser pressionado
    toqueLongo.minimumPressDuration = 0.1;
    [mapKit addGestureRecognizer:toqueLongo];
    
    //Inicia o GeoCoder
    ceo = [[CLGeocoder alloc]init];
    loc = [[CLLocation alloc]initWithLatitude:32.00 longitude:21.322]; //insert your coordinatesz

    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  NSLog(@"Iniciando GeoCoder");
              
              }];
    //Inicia o jogo
    [self iniciarJogo];
    
    //Tipo do mapa
    mapKit.mapType = MKMapTypeStandard;
    mapKit.delegate = self;
}

- (void) iniciarJogo
{
    int numberRandom = arc4random_uniform(qtd);
    paisSearch = paisesArray[numberRandom];
//    NSString *texto = [NSString stringWithFormat:@"Procure por: %@", paisSearch];
    lblPais.text = paisSearch;
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSString *titulo = [languageArray objectAtIndex:0];
    NSString *content = [languageArray objectAtIndex:1];
    NSString *button = [languageArray objectAtIndex:2];
    
    [alert showSuccess:titulo subTitle:content closeButtonTitle:button duration:0.0f];
    [alert alertIsDismissed:^{
        [self comecarJogo];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) startCountdown:(int)tempoInicial
{
    //Quantidade de segundos do jogo.
    counter = tempoInicial;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(decrementTimer:)                                                              userInfo:nil repeats:YES];
}

- (void)decrementTimer:(NSTimer *)timer
{
    NSLog(@"Tempo: %@", lblTime.text);
    counter = counter - 1;
    lblTime.text = [NSString stringWithFormat:@"%d",counter];
    
    if (counter <= 5) {
        lblTime.textColor = [UIColor redColor];
    } else {
        lblTime.textColor = [UIColor colorWithRed:101.0f/255.0f
                                            green:186.0f/255.0f
                                             blue:105.0f/255.0f
                                            alpha:1.0f];
    }
    
    //5 Segundos finais
    if (counter>0 && counter <=5) {
        [self som:@"beep-07.mp3"];
    }
    
    //(GAME-OVER) - O TEMPO ACABOU
    if (counter <= 0) {
        [self som:@"beep-09.mp3"];
        [timer invalidate];
        mapKit.userInteractionEnabled = false;
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        [alert alertIsDismissed:^{
            //Alerta de encerramento
            [self backToMenu];
        }];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMMM dd, yyyy (EEEE) HH:mm:ss z Z"];
        
        int pontuacaoFinal = [lblPoint.text intValue];
        [[GameKitHelper sharedGameKitHelper] reportScore:pontuacaoFinal];
        
        NSString *titulo = [languageArray objectAtIndex:3];
        NSString *content = [languageArray objectAtIndex:4];
        NSString *button = [languageArray objectAtIndex:5];
        
        NSString *texto = [NSString stringWithFormat:content, lblPoint.text];
        [alert showInfo:self title:titulo subTitle:texto closeButtonTitle:button duration:0.0f];
    }
}

- (void) exibirMensagem:(NSString *)txtMensagem tituloMensagem:(NSString *)titulo tituloBotao:(NSString *)botao
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:txtMensagem delegate:self cancelButtonTitle:nil otherButtonTitles:botao, nil];
    [alert show];
}

- (void) comecarJogo
{
    [self startCountdown:20];
}


- (void) adicionaPontuacao {
    NSInteger pontuacao = [lblPoint.text integerValue];
    if ([lblTime.text intValue] >= 0) {
        pontuacao = pontuacao + [lblTime.text intValue];
    }

    lblPoint.text = [NSString stringWithFormat:@"%ld",pontuacao];
}

- (void) proximoPais
{
    counter = 20;
    //Seleciona o proximo pais.
    int numberRandom = arc4random_uniform(qtd);
    paisSearch = paisesArray[numberRandom];
    lblPais.text = paisSearch;
    
}

- (int) gerarNumero
{
    int n = arc4random_uniform(4);
    
    int contador=0;
    if (numerosSorteados.count == 4) {
        [numerosSorteados removeAllObjects];
    }
    
    if (numerosSorteados.count == 0) {
        [numerosSorteados addObject:[NSDecimalNumber numberWithInt:n]];
        return n;
    } else {
        while (contador > 0) {
            contador = 0;
            int n = arc4random_uniform(qtd);
        for (int i=0; i<numerosSorteados.count; i++) {
            if (numerosSorteados[i] == [NSDecimalNumber numberWithInt:n]) {
                contador++;
                }
            }
        }
        return n;
    }
}

- (void) save: (NSString *)pontuacao data:(NSString *)data
{
    Score *sc = [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:self.managedObjectContext];

    sc.pontuacao = pontuacao;
    sc.data = data;
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Erro");
    }
}
//MARK: Pinos
- (void) adicionarPino:(UIGestureRecognizer *)gesto {
    if (gesto.state == UIGestureRecognizerStateBegan) {
        CGPoint ponto  = [gesto locationInView:self.view];
        CLLocationCoordinate2D coordenadas = [mapKit convertPoint:ponto toCoordinateFromView:mapKit];
        MKPointAnnotation *pino = [[MKPointAnnotation alloc] init];
        pino.coordinate = coordenadas;

        ceo = [[CLGeocoder alloc]init];
        loc = [[CLLocation alloc]initWithLatitude:pino.coordinate.latitude longitude:pino.coordinate.longitude]; //insert your coordinatesz
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
                      NSLog(@"Pais: %@",placemark.country);
                      if ([paisSearch isEqualToString:placemark.country]) {
                          [self adicionaPontuacao];
                          [self som:@"acerto.mp3"];
                          NSLog(@"Você Acertou!");
                          [self proximoPais];
                      } else {
                          [self som:@"beep4.mp3"];
                          AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                          NSLog(@"Você errou - 5 segundos!, MapKit:%@ -> Search:%@", placemark.country, paisSearch);
                          counter = counter - 5;
                      }
                  }
         ];
        [mapKit addAnnotation:pino];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(removerPino)
                                       userInfo:nil
                                        repeats:NO];

    }
}
                     
- (void) removerPino
{
    [mapKit removeAnnotation:[mapKit.annotations lastObject]];
}

//MARK: Métodos dos pinos(Annotations)

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapKit dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationViewID"];
    }
    
    annotationView.image = [UIImage imageNamed:@"target.png"];
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)backToMenu {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:@"0" forKey:@"inMap"];
    [myTimer invalidate];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)pauseGame:(id)sender {
    
    [self pauseTimer];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    
    NSString *stringSairJogo = [languageArray objectAtIndex:9];
    NSString *stringResetarJogo = [languageArray objectAtIndex:10];
    [alert addButton:stringSairJogo target:self selector:@selector(backToMenu)];
    [alert addButton:stringResetarJogo target:self selector:@selector(resetGame)];

    NSString *titulo = [languageArray objectAtIndex:6];
    NSString *content = [languageArray objectAtIndex:7];
    NSString *button = [languageArray objectAtIndex:8];
    
    [alert showCustom:self image:[UIImage imageNamed:@"gear.png"] color:color title:titulo subTitle:content closeButtonTitle:button duration:0.0f];
    
    [alert alertIsDismissed:^{
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *inMap = [prefs stringForKey:@"inMap"];
            NSString *resetGame = [prefs stringForKey:@"resetGame"];
        NSLog(@"Restoration Identifier: %@", self.restorationIdentifier);
        if ([inMap isEqualToString:@"1"] && [resetGame isEqualToString:@"0"]) {
           [self startTimer];
        }
    }];
}

- (void) resetGame
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:@"1" forKey:@"resetGame"];
    [myTimer invalidate];
    lblPoint.text = @"0";
    [self iniciarJogo];
}
//MARK: Funções de Som
- (void) som:(NSString *)audio{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], audio];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer play];
}
//MARK: Funções para pausar o jogo
-(void) startTimer {
    [self startCountdown:timerElapsed];
}

-(void) fired {
    [myTimer invalidate];
    myTimer = nil;
//    timerElapsed = 0.0;
    [self startTimer];
    // react to timer event here
}

-(void) pauseTimer {
    [myTimer invalidate];
    myTimer = nil;
    timerElapsed = [lblTime.text doubleValue];
}

@end
